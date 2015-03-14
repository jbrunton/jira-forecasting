class ReportsController < ApplicationController
  before_action :set_project
  
  def show
  end
  
  def epic_cycle_times
    @epics = @project.epics.
      select{ |epic| epic.completed }.
      sort_by{ |epic| epic.cycle_time }
  end
  
  def epics_by_size
    @epics_by_size = ['S', 'M', 'L'].inject({}) do |epics_by_size, size|
      epics_by_size.merge(size => @project.epics.select{ |epic| epic.size == size })
    end
  end
  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end 
end
