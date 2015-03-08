module JiraRequests
  extend ActiveSupport::Concern
  
  def request_rapid_boards
    response = do_request('https://jbrunton.atlassian.net/rest/greenhopper/1.0/rapidviews/list')
    response['views']
  end
  
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