require 'rails_helper'

RSpec.describe IssueBuilder do
  describe "#parse_response" do
    let(:json) {
<<-END
{
    "id": "10400",
    "self": "https://example.com/rest/api/2/issue/10400",
    "key": "DEMO-101",
    "fields": {
        "issuetype": {
            "name": "Story"
        },
        "summary": "Example Story"
    }
}
END
    }
    
    let(:issue) { IssueBuilder.new(JSON.parse(json)).build }

    it "sets the key" do
      expect(issue.key).to eq('DEMO-101')
    end

    it "sets the self" do
      expect(issue.self).to eq('https://example.com/rest/api/2/issue/10400')
    end

    it "sets the summary" do
      expect(issue.summary).to eq('Example Story')
    end
  end
end
