class IssuesController < ApplicationController
  include IssueParser
  include JiraRequests
  
  def index
    @epics = Issue.where(issue_type: 'epic')
  end
  
  def sync
    Issue.delete_all
    
    epic_response = request_epics
    epics = parse_issue_response(epic_response)
    epics.each do |epic|
      issue_response = request_issues(epic.key)
      issues = parse_issue_response(issue_response)
      issues.each do |issue|
        epic.issues.append(issue)
      end
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
