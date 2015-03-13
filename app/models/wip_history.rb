class WipHistory < ActiveRecord::Base
  belongs_to :issue
  
  def self.recompute
    WipHistory.delete_all
    
    events = Event.compute_all
    return if events.length == 0
    
    events_by_date = events.group_by{ |e| e.time.to_date }
    
    from_date = events.first.time.to_date
    to_date = events.last.time.to_date + 1.day
    
    epics = []
    dates = date_range(from_date, to_date)
    range = dates.each do |date|
      events_for_day = events.select{ |e| date <= e.time && e.time < date + 1.day }
      started_events = events_for_day.select{ |e| e.event_type == 'started' }
      completed_events = events_for_day.select{ |e| e.event_type == 'completed' }
      
      started_events.each{ |event| epics << event.epic }
      completed_events.each{ |event| epics.delete(event.epic) }

      epics.each{ |epic| WipHistory.create(date: date, issue: epic) }
    end
  end
  
private
  def self.date_range(start_date, end_date)
    dates = [start_date]
    while dates.last < end_date - 1.day
      dates << (dates.last + 1.day)
    end 
    dates
  end
end
