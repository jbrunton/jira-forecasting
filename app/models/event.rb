class Event
  attr_reader :time
  attr_reader :event_type
  attr_reader :epic
  
  def initialize(opts)
    @time = opts[:time]
    @event_type = opts[:event_type]
    @epic = opts[:epic]
  end
  
  def self.compute_all
    epics = Issue.where(issue_type: 'epic')
    
    events = []
    
    epics.each do |epic|
      events.push(Event.new(time: epic.started, event_type: 'started', epic: epic)) if (epic.started)
      events.push(Event.new(time: epic.completed, event_type: 'completed', epic: epic)) if (epic.completed)
    end
    
    events.sort_by{ |event| event.time }
  end
end
