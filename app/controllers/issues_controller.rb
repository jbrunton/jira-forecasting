class IssuesController < ApplicationController
  include IssueParser
  include JiraRequests
  
  def index
    @issues = Issue.all
  end
  
  def sync
    Issue.delete_all
    
    epic_response = request_epics
    epics = parse_issue_response(epic_response)
    epics.each do |epic_data|
      epic = Issue.create(epic_data)
      issue_response = request_issues(epic_data[:key])
      issues = parse_issue_response(issue_response)
      issues.each do |issue|
        epic.issues.create(issue)
      end
    end
    
    @issues = Issue.all
    
    render "index"
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
