require 'rails_helper'

RSpec.describe RapidBoardBuilder do
  describe "#build" do
    let (:query) { "some query" }
    let (:name) { "Some Board" }
    let (:json) {
      <<-END
      {
        "id": 2,
        "name": "#{name}",
        "filter":
        {
          "id": 10001,
          "name": "Filter for Another Project",
          "query": "#{query}"
        }
      }  
      END
    }
    
    let(:rapid_board) { RapidBoardBuilder.new(JSON.parse(json)).build }

    it "sets the id" do
      expect(rapid_board.id).to eq(2)
    end
    
    it "sets the query" do
      expect(rapid_board.query).to eq(query)
    end
    
    it "sets the name" do
      expect(rapid_board.name).to eq(name)
    end
  end
end
