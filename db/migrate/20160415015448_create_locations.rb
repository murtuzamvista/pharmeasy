class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :name, null: false, unique: true
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :city, null: false

      t.timestamps null: false
    end
  end
end
