class Issue < ActiveRecord::Base
  validates :issue_type, presence: true, inclusion: { in: %w(epic story) } 
end
