class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :name, null: false, unique: true
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
