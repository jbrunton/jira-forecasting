require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe "#compute_size!" do
    context "if the epic has a t-shirt-size" do
      it "sets the size of the epic to the t-shirt size" do
        epic = Issue.new(summary: "Small Epic [S]", issue_type: 'epic')
        epic.compute_size!
        expect(epic.size).to eq('S')
      end
    end
    
    context "otherwise" do
      it "set the size of the epic to nil" do
        epic = Issue.new(summary: "Some Epic", issue_type: 'epic')
        epic.compute_size!
        expect(epic.size).to be_nil
      end
    end
  end
end
