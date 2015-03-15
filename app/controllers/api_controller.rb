class ApiController < ApplicationController
  before_action :set_project, :set_filter
  
  def wip
    # TODO: limit WIP data by project
    wip_histories = WipHistory.all.
      select{ |history| @filter.allow_date(history.date) }.
      map{ |history| { date: history.date, id: history.issue.id, summary: history.issue.summary, key: history.issue.key } }.
      # select{ |history| history.project.id == @project.id }.
      group_by{ |history| history[:date] }
    
    respond_to do |format|
      format.json { render json: wip_histories.to_json }
    end
  end
  
  def cycle_time
    epics = @project.epics.
      select{ |epic| epic.cycle_time && @filter.allow_date(epic.completed) }.
      sort_by{ |epic| epic.completed }

    respond_to do |format|
      format.json { render json: epics.to_json(:methods => [:cycle_time]) }
    end
  end
  
  def epics_by_day
    epics = @project.epics
  end
  
private
  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end
  
  def set_filter
    @filter = Filter.new(params[:filter] || "")
  end
end
