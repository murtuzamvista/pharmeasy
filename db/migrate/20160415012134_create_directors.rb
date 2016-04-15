class CreateDirectors < ActiveRecord::Migration
  def up
    create_table :directors do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end
  def down
    drop_table :directors
  end
end
