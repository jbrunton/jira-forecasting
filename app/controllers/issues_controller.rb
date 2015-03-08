class IssuesController < ApplicationController
  include IssueParser
  include JiraRequests
  
  def index
    @epics = Issue.where(issue_type: 'epic')
  end
  
  def test
    WebsocketRails[:status].trigger(:status_update, "test!,")
    @epics = []
    render "index"
  end
  
  def sync
    Issue.delete_all
    
    epic_response = request_epics
    epics = parse_issue_response(epic_response)
    WebsocketRails[:status].trigger(:status_update, 'Loaded epics')
    LoadEpicJob.new(epics, 0, params).enqueue
    
    render nothing: true
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
