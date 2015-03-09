require 'rails_helper'

RSpec.describe JiraClient do
  let(:domain) { 'http://www.example.com' }
  let(:username) { 'some_user' }
  let(:password) { 's0m3 passw0rd' }
  let(:params) { ActionController::Parameters.new(username: username, password: password) }

  let(:dummy_response) { 'some response' }
  
  before(:each) do
    @client = JiraClient.new(domain, params)
  end

  describe "#request" do
    it "makes a request" do
      stub_request(:get, "https://#{username}:#{password}@www.example.com:80/some/url")
        .to_return(body: dummy_response)

      response = @client.request(:get, 'some/url')
      
      expect(response).to eq(dummy_response)
    end
  end
end
