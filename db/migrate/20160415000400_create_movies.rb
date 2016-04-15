class CreateMovies < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE movie_status AS ENUM ('active', 'inactive', 'deleted');
    SQL
    create_table :movies do |t|
      t.string :title, null: false, unique: true
      t.integer :release_year
      t.string :production_company
      t.string :fun_facts
      t.string :distributor
      t.column :status, :movie_status, null: false, index: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :movies;
    execute <<-SQL
      DROP TYPE movie_status;
    SQL
  end
end
