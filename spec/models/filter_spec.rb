require 'rails_helper'

RSpec.describe Filter do
  describe "#allow_date" do
    it "allows all dates if no filter is specified" do
      filter = Filter.new("")
      expect(filter.allow_date(DateTime.now)).to eq(true)
    end
    
    it "allows dates in a range" do
      filter = Filter.new("1 Jul 2015-1 Aug 2015")
      expect(filter.allow_date(DateTime.new(2015, 7, 1))).to eq(true)
      expect(filter.allow_date(DateTime.new(2015, 8, 2))).to eq(false)
    end
    
    it "allows conjunctions of ranges" do
      filter = Filter.new("1 Jul 2015-1 Aug 2015, 1 Sep 2015-1 Oct 2015")
      expect(filter.allow_date(DateTime.new(2015, 7, 1))).to eq(true)
      expect(filter.allow_date(DateTime.new(2015, 8, 2))).to eq(false)
      expect(filter.allow_date(DateTime.new(2015, 9, 1))).to eq(true)
    end
  end
end
