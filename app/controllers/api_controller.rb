class ApiController < ApplicationController
  def wip
    wip_histories = WipHistory.all.group_by{ |history| history.date }
    
    respond_to do |format|
      format.json { render json: wip_histories.to_json(:include => :issue) }
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
  
  def epics_by_day
    epics = Issue.where(issue_type: 'epic')
  end
end
