class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  def ok_value(de_normalize=false)
    if de_normalize
      Restaurant.find(self.restaurant_id).de_normalize_rating(super)
    else
      super 
    end
  end

  def before_save
    # ok values will always be sent un normalized
    Rails.logger.warn self.inspect
    self.ok_value = Restaurant.find(self.restaurant_id).normalize_rating(self.ok_value)
  end

end
