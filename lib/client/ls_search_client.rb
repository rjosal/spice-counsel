require 'json'

class LsSearchClient

  LS_SEARCH_SERVER = 'http://lssearch.phl'

  def search(query, place)
    uri = "#{LS_SEARCH_SERVER}/search?query=#{query}&place=#{place}"
    raw_json = Net::HTTP.get( URI.parse(uri) )
#TODO limit search to spicy restaurants via tags
#TODO return [] of Entity
  end

  def get_entity(eid)
    Entity.new :name => 'Spicy Food Place', :address => '1 Main St.', :id => eid
  end

  class Entity
    attr_accessor :id, :name, :address, :city, :state, :zip, :phone
    def initialize(parms={})
      parms.each do |attr, val|
        self.send(attr.to_s+'=', val)
      end
    end
  end
end
