class CreateJoinTableMovieLocation < ActiveRecord::Migration
  def change
    create_join_table :movies, :locations, :id => false do |t|
      # t.index [:movie_id, :location_id]
      # t.index [:location_id, :movie_id]
    end
  end
end
