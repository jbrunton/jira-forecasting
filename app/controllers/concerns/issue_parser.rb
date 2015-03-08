module IssueParser
  extend ActiveSupport::Concern
  
  def parse_issue_response(response)
    issues = response['issues']
    issues.map do |issue_json|
      parse_issue(issue_json)
    end
  end

  def parse_issue(issue_json)
    attrs = {
      :key => parse_key(issue_json),
      :self => parse_self(issue_json),
      :summary => parse_summary(issue_json),
      :issue_type => parse_issue_type(issue_json),
    }
    
    if attrs[:issue_type] == 'story'
      attrs[:started] = parse_started_date(issue_json)
      attrs[:completed] = parse_completed_date(issue_json)
    end

    Issue.create(attrs)
  end

private
  def parse_key(issue_json)
    issue_json['key']
  end
  
  def parse_self(issue_json)
    issue_json['self']
  end
  
  def parse_summary(issue_json)
    issue_json['fields']['summary']
  end
  
  def parse_issue_type(issue_json)
    issue_json['fields']['issuetype']['name'] == 'Epic' ? 'epic' : 'story'
  end
  
  def is_status_transition(item)
    item['field'] == "status"
  end
  
  def is_started_transition(item)
    is_status_transition(item) &&
      (item['toString'] == "In Progress" || item['toString'] == "Started")
  end
  
  def is_completed_transition(item)
    is_status_transition(item) &&
      (item['toString'] == "Done" || item['toString'] == "Closed")
  end
  
  def parse_started_date(issue_json)
    return nil if issue_json['changelog'].nil?

    histories = issue_json['changelog']['histories']

    started_transitions = histories.select do |entry|
      entry['items'].any?{|item| is_started_transition(item)}
    end
    
    if started_transitions.any?
      started_transitions.first['created']
    else
      nil
    end
  end
  
  def parse_completed_date(issue_json)
    return nil if issue_json['changelog'].nil?

    histories = issue_json['changelog']['histories']

    last_transition = histories.select do |entry|
      entry['items'].any?{|item| is_status_transition(item)}
    end.last
    
    if !last_transition.nil? &&
      last_transition['items'].any?{|item| is_completed_transition(item)}
        last_transition['created']
    else
      nil 
    end
  end
end
