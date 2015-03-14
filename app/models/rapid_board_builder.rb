class RapidBoardBuilder
  def initialize(json)
    @json = json
  end
  
  def build
    attrs = {
      id: id,
      query: query
    }
    
    RapidBoard.new(attrs)
  end

private
  def id
    @json['id']
  end
  
  def query
    @json['filter']['query']
  end
end
