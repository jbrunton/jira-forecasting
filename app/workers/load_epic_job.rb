class LoadEpicJob
  include JiraRequests
  include IssueParser
  include Celluloid
  
  # include Sidekiq::Worker
  # sidekiq_options retry: false

  attr_reader :params

  def load(index, params)
    sleep(index)
    # @params = params
    # epic = Issue.find(epic_id)
    #
    # issue_response = request_issues(epic.key)
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

    WebsocketRails[:status].trigger(:status_update, { event: 'loaded_epic' })

    # epic
  end
end
