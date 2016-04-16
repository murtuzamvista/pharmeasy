class MovieService
  class << self
    def sync
      city = 'San Francisco'
      url = $APP_CONFIG['movies_url']
      movies = JSON.parse(RestClient.get(url))
      movies.each do |movie|
        next if movie['locations'].blank? ||
                movie['writer'].blank? ||
                movie['director'].blank?
        db_movie = Movie.where(title: movie['title'].strip).first_or_create
        movie_actors_name = db_movie.actors.collect(&:name)
        %w(actor_1 actor_2 actor_3).each do |actor|
          next if movie[actor].blank? || \
                  movie_actors_name.include?(movie[actor])
          db_actor = Actor.where(name: movie[actor].strip).first_or_create
          db_movie.actors << db_actor
        end

        if db_movie.locations.collect(&:name).exclude?(movie['locations'].strip)
          db_location = Location.where(name: movie['locations'].strip,
                                       city: city).first_or_create
          db_movie.locations << db_location
        end

        if db_movie.writers.collect(&:name).exclude?(movie['writer'].strip)
          db_writer = Writer.where(name: movie['writer'].strip).first_or_create
          db_movie.writers << db_writer
        end

        if db_movie.directors.collect(&:name).exclude?(movie['director'].strip)
          db_director = Director.where(name:
                                        movie['director'].strip).first_or_create
          db_movie.directors << db_director
        end

        # Optional
        db_movie.release_year = movie.fetch('release_year', '')
        db_movie.production_company = movie.fetch('production_company', '')
        db_movie.fun_facts = movie.fetch('fun_facts', '')
        db_movie.distributor = movie.fetch('distributor', '')
        db_movie.save!
      end
      movies.count
    end

    def by_title(title)
      movie = Movie.where(title: title).first
      return if movie.blank?
      payload(movie)
    end

    def all
      Movie.all.collect{|movie| payload(movie)}
    end

    def payload(movie)
      {
        title: movie.title,
        actors: movie.actors.collect(&:name),
        locations: movie.locations.collect do |location|
                     {
                       name: location.name,
                       city: location.city,
                       latitude: location.latitude,
                       longitude: location.longitude
                     }
                   end,
        writers: movie.writers.collect(&:name),
        directors: movie.directors.collect(&:name),
        fun_facts: movie.fun_facts,
        release_year: movie.release_year,
        production_company: movie.production_company,
        distributor: movie.distributor
      }
    end
  end
end
