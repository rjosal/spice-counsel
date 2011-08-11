require 'json'

class LsSearchClient
  # keys in the raw json
  RESULTS           = 'results'
  ENTITY_RESULT_SET = 'entityResultSet'
  HITS              = 'hits'

  LS_SEARCH_SERVER = 'http://lssearch.phl'

  def search(query, place)
    uri = "#{LS_SEARCH_SERVER}/search?query=#{query}&place=#{place}"
    raw_json = Net::HTTP.get( URI.parse(uri) )
#TODO accept tags
    entities = []
    JSON.parse(raw_json)[RESULTS][ENTITY_RESULT_SET][HITS].each do |json_entity|
      entities << Entity.new(:id => json_entity['entity_id'],
                             :name => json_entity['name'],
                             :address => json_entity['address'],
                             :city => json_entity['places']['city'][1],
                             :state => json_entity['places']['state'][1],
                             :zip => json_entity['places']['zip'][1],
                             :phone => json_entity['arbitrated_phones']['main']
                            )
    end
    entities
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
