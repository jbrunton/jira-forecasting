class SyncController < ApplicationController
  def index
  end
  
  def sync
    Issue.delete_all
    
    jira_client = JiraClient.new(params['domain'], params)
    
    rapid_board = jira_client.get_rapid_board(params['rapid_board_id'].to_i)
    
    epics = jira_client.search_issues(query: "issuetype=Epic AND " + rapid_board.query)
    epics.each do |epic|
      issues = jira_client.search_issues(
        expand: ['changelog'],
        query: "\"Epic Link\"=#{epic.key}")

      issues.each do |issue|
        epic.issues.append(issue)
      end

      started_dates = epic.issues.map{|issue| issue.started}.compact
      if started_dates.any?
        epic.started = started_dates.min
      end

      completed_dates = epic.issues.map{|issue| issue.completed}.compact
      unless completed_dates.length < issues.length # i.e. no issues are incomplete
        epic.completed = completed_dates.max
      end
      
      epic.save
    end
    
    Issue.recompute_sizes!
    
    WipHistory.recompute
    
    @epics = Issue.where(issue_type: 'epic')
    
    redirect_to controller: 'issues', action: 'index'
  end
end
