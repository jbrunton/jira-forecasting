class ReportsController < ApplicationController
  def cycle_time
  end
  
  def epics_by_size
    @epics_by_size = ['S', 'M', 'L'].inject({}) do |epics_by_size, size|
      epics_by_size.merge(size => Issue.epics.select{ |epic| epic.size == size })
    end
  end
end
