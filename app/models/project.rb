class Project < ActiveRecord::Base
  has_many :issues
  
  def epics
    issues.where(issue_type: 'epic')
  end
end
