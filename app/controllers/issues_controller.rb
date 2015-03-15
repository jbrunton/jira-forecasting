class IssuesController < ApplicationController
  before_action :set_project, only: [:index]
  
  def index
    if @project
      @epics = @project.issues.where(issue_type: 'epic')
    else
      @epics = Issue.all.where(issue_type: 'epic')
    end
  end
  
  def show
    @issue = Issue.find(params[:id])
  end
  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end  
end
