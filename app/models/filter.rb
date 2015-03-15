class Filter
  def initialize(filter)
    @date_ranges = filter.split(",").map do |x|
      x.split("-").map{ |x| DateTime.parse(x.strip) }
    end
  end
  
  def allow_date(date)
    if @date_ranges.length > 0
      @date_ranges.select{ |range| range[0] <= date && date <= range[1] }.length > 0
    else
      true
    end
  end
end
