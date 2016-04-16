class CreateJoinTableMovieActor < ActiveRecord::Migration
  def change
    create_join_table :movies, :actors, :id => false do |t|
      # t.index [:movie_id, :actor_id]
      # t.index [:actor_id, :movie_id]
    end
  end
end
