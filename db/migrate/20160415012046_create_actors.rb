class CreateActors < ActiveRecord::Migration
  def up
    create_table :actors do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :actors
  end
end
