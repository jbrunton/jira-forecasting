class IssuesController < ApplicationController
  EPIC_LINK_FIELD_ID = 10008
  
  def index
    @epics = Issue.where(issue_type: 'epic')
  end
  
  def sync
    Issue.delete_all
    
    jira_client = JiraClient.new('https://jbrunton.atlassian.net', params)
    
    raw_epics = jira_client.search_issues(query: 'project%20=%20%22Demo%20Project%22%20AND%20issuetype%20=%20%22Epic%22')
    epics = raw_epics.map do |raw_epic|
      IssueBuilder.new(raw_epic).build
    end
    epics.each do |epic|
      raw_issues = jira_client.search_issues(
        expand: ['changelog'],
        query: "cf[#{EPIC_LINK_FIELD_ID}]=#{epic.key}")

      issues = raw_issues.map do |raw_issue|
        IssueBuilder.new(raw_issue).build
      end
      issues.each do |issue|
        epic.issues.append(issue)
      end

      started_dates = epic.issues.map{|issue| issue.started}.compact
      if started_dates.any?
        epic.started = started_dates.min
      end

      completed_dates = epic.issues.map{|issue| issue.completed}.compact
      unless completed_dates.length < issues.length # i.e. no issues are incomplete
        epic.completed = completed_dates.max
      end
      
      epic.save
    end
    
    @epics = Issue.where(issue_type: 'epic')
    
    render "index"
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
