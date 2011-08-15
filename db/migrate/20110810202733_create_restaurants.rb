class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.integer :eid
      t.integer :min_scale
      t.integer :max_scale

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurants
  end
end
