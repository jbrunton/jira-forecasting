class Issue < ActiveRecord::Base
  validates :issue_type, presence: true, inclusion: { in: %w(epic story) } 
  
  has_many :issues, class_name: "Issue", foreign_key: "epic_id"
 
  belongs_to :epic, class_name: "Issue"
  
  def cycle_time
    (completed - started) / 1.day unless completed.nil?
  end
end
