class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end
  
  def sync
    uri = URI.parse("https://jbrunton.atlassian.net/rest/api/2/search")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth params['username'], params['password']
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end
    
    Issue.delete_all
    
    parse_response(res)
    
    @issues = Issue.all
    render "index"
  end
private
  def parse_response(response)
    json = JSON.parse(response.body)
    issues = json['issues']
    issues.map do |issue_json|
      Issue.create(
        :key => issue_json['key'],
        :self => issue_json['self'],
        :summary => issue_json['fields']['summary'])
    end
  end
end
