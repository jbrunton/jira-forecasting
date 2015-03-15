class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :sync]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        unless @project.domain.nil?
          client = JiraClient.new(@project.domain, params)
          @rapid_boards = client.get_rapid_boards
        end

        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def sync
    @project.issues.destroy_all
    
    jira_client = JiraClient.new(@project.domain, params)
    
    rapid_board = jira_client.get_rapid_board(@project.rapid_board_id)
    
    epics = jira_client.search_issues(query: "issuetype=Epic AND " + rapid_board.query)
    epics.each do |epic|
      issues = jira_client.search_issues(
        expand: ['changelog'],
        query: "\"Epic Link\"=#{epic.key}")

      issues.each do |issue|
        epic.issues.append(issue)
        issue.project = @project
      end

      started_dates = epic.issues.map{|issue| issue.started}.compact
      if started_dates.any?
        epic.started = started_dates.min
      end

      completed_dates = epic.issues.map{|issue| issue.completed}.compact
      unless completed_dates.length < issues.length # i.e. no issues are incomplete
        epic.completed = completed_dates.max
      end
      
      epic.project = @project
      epic.save
    end
    
    Issue.compute_sizes!(@project)
    
    WipHistory.compute!(@project)
    
    redirect_to @project
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:domain, :rapid_board_id, :name)
    end
end
