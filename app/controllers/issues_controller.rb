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
    WebsocketRails[:status].trigger(:status_update, { event: 'loaded_board', size: epics.length })
    futures = []
    epics.each_with_index do |epic, index|
      epic.save
      job = LoadEpicJob.new
      futures.push(job.future.load(index, params))
      #job.load(epic.id, params)
    end
    
    # futures.each do |f|
    #   epic = f.value
    #   epic.save
    # end
    
    render nothing: true
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
