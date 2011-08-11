class Restaurant < ActiveRecord::Base
  validates_numericality_of :min_scale, :max_scale

  def normalize_rating(rating)
    (rating - self.min_scale) * (100/self.max_scale)
  end
  def de_normalize_rating(rating)
    (rating / (100/self.max_scale)) - self.min_scale
  end
end
