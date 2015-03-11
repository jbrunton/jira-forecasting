require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe "#compute_size!" do
    context "if the epic has a t-shirt-size" do
      it "sets the size of the epic to the t-shirt size" do
        epic = create(:epic, summary: "Small Epic [S]")
        Issue.recompute_sizes!
        expect(epic.reload.size).to eq('S')
      end
    end
    
    context "otherwise" do
      it "sets the size of the epic based on the interquartile range" do
        epics = [
          create(:epic, :completed, cycle_time: 4),
          create(:epic, :completed, cycle_time: 2),
          create(:epic, :completed, cycle_time: 1),
          create(:epic, :completed, cycle_time: 3)
        ]
        
        Issue.recompute_sizes!
        epics.each{ |epic| epic.reload }

        sizes = epics.map{ |epic| epic.size }

        expect(sizes).to eq(['L', 'M', 'S', 'M'])
      end
    end
  end
end
