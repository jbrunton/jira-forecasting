class JiraClient
  def initialize(domain, params)
    @domain = domain
    @credentials = params.slice(:username, :password)
  end
  
  def request(method, relative_url)
    uri = URI::join(@domain, relative_url)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth @credentials['username'], @credentials['password']
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end
    res.body
  end
end
