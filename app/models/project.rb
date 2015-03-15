class Project < ActiveRecord::Base
  has_many :issues

  validates :domain, presence: true
  validates :rapid_board_id, presence: true
  
  def epics
    issues.where(issue_type: 'epic')
  end
end
