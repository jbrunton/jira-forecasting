module IssueParser
  extend ActiveSupport::Concern
  
  def parse_response(response)
    json = JSON.parse(response.body)
    issues = json['issues']
    issues.map do |issue_json|
      Issue.create(
        :key => issue_json['key'],
        :self => issue_json['self'],
        :summary => issue_json['fields']['summary'])
    end
  end
end
