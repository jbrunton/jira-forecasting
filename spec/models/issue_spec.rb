require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:project) { create(:project) }
  
  describe "#compute_size!" do
    context "if the epic has a t-shirt-size" do
      it "sets the size of the epic to the t-shirt size" do
        epic = create(:epic, summary: "Small Epic [S]", project: project)
        Issue.compute_sizes!(project)
        expect(epic.reload.size).to eq('S')
      end
    end
    
    context "otherwise" do
      it "sets the size of the epic based on the interquartile range" do
        epics = [
          create(:epic, :completed, cycle_time: 4, project: project),
          create(:epic, :completed, cycle_time: 2, project: project),
          create(:epic, :completed, cycle_time: 1, project: project),
          create(:epic, :completed, cycle_time: 3, project: project)
        ]
        
        Issue.compute_sizes!(project)
        epics.each{ |epic| epic.reload }

        sizes = epics.map{ |epic| epic.size }

        expect(sizes).to eq(['L', 'M', 'S', 'M'])
      end
    end
  end
end
