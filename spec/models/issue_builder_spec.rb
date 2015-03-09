require 'rails_helper'

RSpec.describe IssueBuilder do
  describe "#build" do
    context "in all cases it" do
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
    
    context "unless the issue type is an epic" do
      let(:json) {
        <<-END
        {
            "id": "10400",
            "self": "https://example.com/rest/api/2/issue/10400",
            "key": "DEMO-101",
            "fields": {
                "issuetype": {
                    "name": "Blah"
                },
                "summary": "Example Story"
            },
            "changelog": {
                "histories": [
                    {
                        "created": "2015-03-05T10:30:00.000+0100",
                        "items": [
                            {
                                "field": "status",
                                "fromString": "To Do",
                                "toString": "In Progress"
                            }
                        ]
                    },
                    {
                        "created": "2015-03-10T10:30:00.000+0100",
                        "items": [
                            {
                                "field": "status",
                                "fromString": "In Progress",
                                "toString": "Done"
                            }
                        ]
                    }
                ]
            }
        }
        END
      }
      
      let(:issue) { IssueBuilder.new(JSON.parse(json)).build }
      
      it "computes the started date" do
        expected_time = DateTime.parse("2015-03-05T10:30:00.000+0100")
        expect(issue.started).to eq(expected_time)
      end
      
      it "computes the completed date" do
        expected_time = DateTime.parse("2015-03-10T10:30:00.000+0100")
        expect(issue.completed).to eq(expected_time)
      end
    end
  end
end
