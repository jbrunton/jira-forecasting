module JiraRequests
  extend ActiveSupport::Concern
  
  EPIC_LINK_FIELD_ID = 10008

  def request_rapid_boards
    response = do_request('https://jbrunton.atlassian.net/rest/greenhopper/1.0/rapidviews/list')
    response['views']
  end
  
  def request_epics
    response = do_request('https://jbrunton.atlassian.net/rest/api/2/search?jql=project%20=%20%22Demo%20Project%22%20AND%20issuetype%20=%20%22Epic%22')
  end
  
  def request_issues(epic_id)
    response = do_request("https://jbrunton.atlassian.net/rest/api/2/search?expand=changelog&jql=cf[#{EPIC_LINK_FIELD_ID}]=#{epic_id}")
  end

private  
  def do_request(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth params['username'], params['password']
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end
end