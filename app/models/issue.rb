class Issue < ActiveRecord::Base
  validates :issue_type, presence: true, inclusion: { in: %w(epic story) } 
  
  has_many :issues, class_name: "Issue", foreign_key: "epic_id"
 
  belongs_to :epic, class_name: "Issue"
  belongs_to :project
  
  def cycle_time
    (completed - started) / 1.day unless completed.nil?
  end
  
  def self.compute_sizes!(project)
    sorted_epics = project.epics.
      select{ |epic| epic.cycle_time }.
      sort_by{ |epic| epic.cycle_time }
      
    incomplete_epics = project.epics.
      select{ |epic| epic.cycle_time.nil? }
      
    quartile_size = sorted_epics.length / 4
    interquartile_size = sorted_epics.length - quartile_size * 2
    
    first_quartile = sorted_epics.take(quartile_size)
    interquartile = sorted_epics.drop(quartile_size).take(interquartile_size)
    last_quartile = sorted_epics.drop(quartile_size + interquartile_size)
    
    {first_quartile => 'S', interquartile => 'M', last_quartile => 'L', incomplete_epics => nil}.each do |epics, size|
      epics.each do |epic|
        size_match = /\[(S|M|L)\]/.match(epic.summary)
        epic.size = size_match[1] unless size_match.nil?
        epic.size = size if epic.size.nil?
        epic.save
      end
    end
  end
end
