class JiraClient
  def initialize(domain, params)
    @domain = domain
    @credentials = params.slice(:username, :password)
  end
  
  def request(method, relative_url)
    uri = URI::join(@domain, relative_url)
    request = setup_request(uri)
    response = issue_request(uri, request)
    JSON.parse(response.body)
  end
  
  def search_issues(opts)
    response = request(:get, "rest/api/2/search?maxResults=9999&jql=#{opts[:query]}")
    response['issues']
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
