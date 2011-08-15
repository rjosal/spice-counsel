require 'client/ls_search_client'

class Restaurant < ActiveRecord::Base

  SEARCH_CLIENT = LsSearchClient.new

  has_many :ratings
  validates_numericality_of :min_scale, :max_scale, :eid

  def validate
    errors.add(:max_scale, " must be greater than Min Scale") if self.max_scale <= self.min_scale
  end

  def normalize_rating(rating)
    ((rating - self.min_scale) * (100.to_f/(self.max_scale-self.min_scale).to_f))
  end

  def de_normalize_rating(rating)
    if 'N/A'.eql?(rating)
      'Undefined'
    else
      ((rating.to_f / (100.to_f/(self.max_scale-self.min_scale).to_f)) + self.min_scale).round
    end 
  end

  def entity
    SEARCH_CLIENT.get_entity self.eid
  end

  def self.top_by_ratings(limit = 3)
    conn = ActiveRecord::Base.connection
    res = []
    if conn
     conn.select_values("select re.id from restaurants re, ratings ra where re.id = ra.restaurant_id group by re.id order by count(*) desc limit #{limit}").each { |id| res << Restaurant.find(id) }
    end
    res
  end
end
