class Rating < ActiveRecord::Base

  def ok_value(de_normalize=false)
    if de_normalize
      Restaurant.find(self.restaurant_id).de_normalize_rating(super)
    else
      super 
    end
  end

  def after_validation_on_create
    # ok values will always be sent un normalized
    Rails.logger.warn self.inspect
    self.ok_value = Restaurant.find(self.restaurant_id).normalize_rating(self.ok_value)
  end

end
