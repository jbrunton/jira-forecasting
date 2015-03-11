class ApiController < ApplicationController
  def wip
    @wip_histories = WipHistory.all
    
    respond_to do |format|
      format.json { render json: @wip_histories }
    end
  end
  
  def cycle_time
    epics = Issue.where(issue_type: 'epic').
      select{ |epic| !epic.completed.nil? }.
      sort_by{ |epic| epic.completed }

    respond_to do |format|
      format.json { render json: epics.to_json(:methods => [:cycle_time]) }
    end
  end
end
