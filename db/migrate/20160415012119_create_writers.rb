class CreateWriters < ActiveRecord::Migration
  def up
    create_table :writers do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :writers
  end
end
