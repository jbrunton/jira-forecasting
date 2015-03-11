class Issue < ActiveRecord::Base
  validates :issue_type, presence: true, inclusion: { in: %w(epic story) } 
  
  has_many :issues, class_name: "Issue", foreign_key: "epic_id"
 
  belongs_to :epic, class_name: "Issue"
  
  def cycle_time
    (completed - started) / 1.day unless completed.nil?
  end
  
  def compute_size!
    size_match = /\[(S|M|L)\]/.match(summary)
    self.size = size_match[1] unless size_match.nil?
  end
  
  def self.recompute_sizes!
    epics.each do |epic|
      epic.compute_size!
      epic.save
    end
  end
  
  def self.epics
    Issue.where(issue_type: 'epic')
  end
end
