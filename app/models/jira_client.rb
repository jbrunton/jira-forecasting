class JiraClient
  def initialize(domain, params)
    @domain = domain
    @credentials = params.slice(:username, :password)
  end
  
  def request(method, relative_url)
    uri = URI::join(@domain, relative_url)
    request = setup_request(uri)
    response = issue_request(uri, request)
    response.body
  end
private
  def setup_request(uri)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth @credentials['username'], @credentials['password']
    request
  end
  
  def issue_request(uri, request)
    Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(request)
    end
  end
end
