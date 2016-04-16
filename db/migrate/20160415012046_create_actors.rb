class CreateActors < ActiveRecord::Migration
  def up
    create_table :actors do |t|
      t.integer :movie_id, default: 0
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :actors
  end
end
