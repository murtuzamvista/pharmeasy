class MovieService
  class << self
    CACHE_NAME = 'movies_locations'
    def sync
      city = 'San Francisco'
      url = $APP_CONFIG['movies_url']
      movies = JSON.parse(RestClient.get(url))
      movies.each do |movie|
        next if movie['locations'].blank? ||
                movie['writer'].blank? ||
                movie['director'].blank?
        movie_title = movie['title'].strip
        db_movie = Movie.where(title: movie_title).first_or_create
        movie_actors_name = db_movie.actors.collect(&:name)
        %w(actor_1 actor_2 actor_3).each do |actor|
          next if movie[actor].blank? || \
                  movie_actors_name.include?(movie[actor])
          db_actor = Actor.where(name: movie[actor].strip).first_or_create
          db_movie.actors << db_actor
        end

        db_location = Location.where(name: movie['locations'].strip,
                                     city: city).first_or_create

        db_movie.locations << db_location if \
          db_movie.locations.collect(&:name).exclude?(movie['locations'].strip)

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
      rebuild_cache
      movies.count
    end

    def rebuild_cache
      movies_cache = {}
      Movie.all.each do |movie|
        movies_cache[movie.title] = payload(movie)
      end
      Rails.cache.write(CACHE_NAME, movies_cache)
    end

    def by_title(title)
      movies = Rails.cache.fetch(CACHE_NAME)
      return if movies.blank?
      movies.fetch(title, nil)
      # movie = Movie.where('upper(title) = ?', title.upcase).first
      # return if movie.blank?
      # payload(movie)
    end

    def all
      Rails.cache.fetch(CACHE_NAME)
      # Movie.all.collect{|movie| payload(movie)}
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

    def search(string)
      movies = Rails.cache.fetch(CACHE_NAME)
      return if movies.blank?
      movies.select { |title| title.to_s.upcase.start_with?(string.upcase) }
      # Movie.where("title ilike ?", "#{string}%").all.collect(&:title).select { |key| key.to_s.upcase.start_with?(string.upcase) }
    end
  end
end
