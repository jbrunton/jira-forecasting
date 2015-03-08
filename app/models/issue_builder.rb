class IssueBuilder
  def initialize(json)
    @json = json
  end
  
  def build
    attrs = {
      :key => parse_key,
      :self => parse_self,
      :summary => parse_summary,
      :issue_type => parse_issue_type
    }
    
    if attrs[:issue_type] == 'story'
      attrs[:started] = parse_started_date
      attrs[:completed] = parse_completed_date
    end

    Issue.create(attrs)
  end

private
  def parse_key
    @json['key']
  end
  
  def parse_self
    @json['self']
  end
  
  def parse_summary
    @json['fields']['summary']
  end
  
  def parse_issue_type
    @json['fields']['issuetype']['name'] == 'Epic' ? 'epic' : 'story'
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
  
  def parse_started_date
    return nil if @json['changelog'].nil?

    histories = @json['changelog']['histories']

    started_transitions = histories.select do |entry|
      entry['items'].any?{|item| is_started_transition(item)}
    end
    
    if started_transitions.any?
      started_transitions.first['created']
    else
      nil
    end
  end
  
  def parse_completed_date
    return nil if @json['changelog'].nil?

    histories = @json['changelog']['histories']

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
