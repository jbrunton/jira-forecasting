class IssuesController < ApplicationController
  def index
    @epics = Issue.where(issue_type: 'epic')
  end
  
  def show
    @issue = Issue.find(params[:id])
  end
  
private
  def select_rapid_board
    rapid_boards = request_rapid_boards
    rapid_boards.first{ |board| board.id == param['board'] }
  end
end
