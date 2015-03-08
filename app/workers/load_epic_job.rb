class LoadEpicJob
  include JiraRequests
  include IssueParser
  
  include Sidekiq::Worker

  attr_reader :params

  def perform(epics, index, params)
    # epic = epics[index]
    #
    # issue_response = request_issues(epic.key)
    sleep(2.seconds)
    WebsocketRails[:status].trigger(:status_update, "Loaded #{index + 1} of #{epics.length} epics")
    # issues = parse_issue_response(issue_response)
    # issues.each do |issue|
    #   epic.issues.append(issue)
    # end
    #
    # started_dates = epic.issues.map{|issue| issue.started}.compact
    # if started_dates.any?
    #   epic.started = started_dates.min
    # end
    #
    # completed_dates = epic.issues.map{|issue| issue.completed}.compact
    # unless completed_dates.length < issues.length # i.e. no issues are incomplete
    #   epic.completed = completed_dates.max
    # end
    #
    # epic.save
    #
    if index + 1 < epics.length
      LoadEpicJob.perform_async(epics, index + 1, params)
    end
  end
end
