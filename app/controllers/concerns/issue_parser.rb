module IssueParser
  extend ActiveSupport::Concern
  
  def parse_issue_response(response)
    issues = response['issues']
    issues.map do |issue_json|
      IssueBuilder.new(issue_json).build
    end
  end
end
