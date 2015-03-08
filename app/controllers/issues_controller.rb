class IssuesController < ApplicationController
  include IssueParser
  include JiraRequests
  
  def index
    @epics = Issue.where(issue_type: 'epic')
  end
  
  def test
    WebsocketRails[:status].trigger(:status_update, "test!")
    @epics = []
    render "index"
  end
  
  def sync
    Issue.delete_all
    
    epic_response = request_epics
    epics = parse_issue_response(epic_response)
    WebsocketRails[:status].trigger(:status_update, 'Loaded epics')
    epics.each_with_index do |epic, index|
      issue_response = request_issues(epic.key)
      WebsocketRails[:status].trigger(:status_update, "Loaded #{index + 1} of #{epics.length} epics")
      issues = parse_issue_response(issue_response)
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
    
    render nothing: true
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
