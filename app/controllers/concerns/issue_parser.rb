module IssueParser
  extend ActiveSupport::Concern
  
  def parse_response(response)
    json = JSON.parse(response.body)
    issues = json['issues']
    issues.map do |issue_json|
      Issue.create(
        :key => parse_key(issue_json),
        :self => parse_self(issue_json),
        :summary => parse_summary(issue_json),
        :issue_type => parse_issue_type(issue_json))
    end
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
end
