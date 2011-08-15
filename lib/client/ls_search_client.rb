require 'json'

class LsSearchClient
  # keys in the raw json
  RESULTS           = 'results'
  ENTITY_RESULT_SET = 'entityResultSet'
  HITS              = 'hits'

  LS_SEARCH_SERVER = 'http://lssearch.phl'

  def search(query, place, limit=6)
    raise ArgumentError unless limit.is_a?(Fixnum)
    uri = "#{LS_SEARCH_SERVER}/search?query=#{CGI::escape(query)}&place=#{CGI::escape(place)}&limit=#{limit}"
    raw_json = Net::HTTP.get( URI.parse(uri) )
#TODO accept tags
    entities = []
    JSON.parse(raw_json)[RESULTS][ENTITY_RESULT_SET][HITS].each do |json_entity|
      entities << Entity.new_from_json_entity( json_entity )
    end
    entities
  end

  def get_entity(eid)
    uri = "#{LS_SEARCH_SERVER}/search?entity=#{eid}"
    raw_json = Net::HTTP.get( URI.parse(uri) )
    json_entity = JSON.parse(raw_json)[RESULTS][ENTITY_RESULT_SET][HITS][0]
    Entity.new_from_json_entity( json_entity )
  end

  class Entity
    attr_accessor :id, :name, :address, :city, :state, :zip, :phone
    def initialize(parms={})
      parms.each do |attr, val|
        self.send(attr.to_s+'=', val)
      end
    end

    def self.new_from_json_entity(json_entity)
      new(:id => json_entity['entity_id'],
          :name => json_entity['name'],
          :address => json_entity['address'],
          :city => (json_entity['places']['city'][1] rescue ""),
          :state => (json_entity['places']['state'][1] rescue ""),
          :zip => (json_entity['places']['zip'][1] rescue ""),
          :phone => (json_entity['arbitrated_phones']['main'].to_s.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'(\1) \2-\3') rescue "")
         )
    end
  end
end
