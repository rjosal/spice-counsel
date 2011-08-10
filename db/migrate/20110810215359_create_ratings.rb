class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :ok_value

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
