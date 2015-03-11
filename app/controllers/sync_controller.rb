class SyncController < ApplicationController
  EPIC_LINK_FIELD_ID = 10008
  
  def index
  end
  
  def sync
    Issue.delete_all
    
    jira_client = JiraClient.new('https://jbrunton.atlassian.net', params)
    
    epics = jira_client.search_issues(query: 'project%20=%20%22Demo%20Project%22%20AND%20issuetype%20=%20%22Epic%22')
    epics.each do |epic|
      issues = jira_client.search_issues(
        expand: ['changelog'],
        query: "cf[#{EPIC_LINK_FIELD_ID}]=#{epic.key}")

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