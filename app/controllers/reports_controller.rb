class ReportsController < ApplicationController
  before_action :set_project, :set_filter
  
  def show
  end
  
  def epic_cycle_times
    @epics = @project.epics.
      select{ |epic| epic.cycle_time }.
      sort_by{ |epic| epic.cycle_time }
  end
  
  def epics_by_size
    @epics_by_size = ['S', 'M', 'L'].inject({}) do |epics_by_size, size|
      epics_by_size.merge(size => @project.epics.select{ |epic| epic.size == size })
    end
  end
  
  def forecast
    if params
      epics = @project.epics.select{ |epic| epic.cycle_time && @filter.allow_issue(epic) }
      opts = {}
      opts.merge!({'S' => params[:small_count].to_i}) if params[:small_count].to_i > 0
      opts.merge!({'M' => params[:medium_count].to_i}) if params[:medium_count].to_i > 0
      opts.merge!({'L' => params[:large_count].to_i}) if params[:large_count].to_i > 0
      @forecast = MonteCarloPicker.new(epics).play(opts)
    end
  end
  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end 
  
  def set_filter
    @filter = Filter.new(params[:filter] || "")
  end
end
