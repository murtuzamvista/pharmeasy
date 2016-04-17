# @restful_api 1.0
#
# DF San Francisco Movies API
#
class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # @url /movies/sync
  # @action PUT
  #
  # Add or update the movies information obtained from the data.sfgov API into our system
  #
  # @response [JSON]
  #
  # @example_request_description Lets sync up all the movies
  # @example_request PUT /movies/sync
  # @example_response_description Displays the number of movies added and updated.
  # @example_response
  #   ```json
  #   {
  #     "payload": nil,
  #     "meta": {
  #       "affected_records": 1000
  #     }
  #   }
  #   ```

  def sync
    puts "SYNC"
    affected_records = MovieService.sync
    render json: { payload: nil, meta: { affected_records: affected_records } },
           status: :ok
  end

  # @url /movies
  #
  # @action GET
  #
  # Get all the movies
  #
  # @response [JSON]
  #
  # @example_request_description Lets get all the movies
  # @example_request GET /movies
  # @example_response_description Get all the movies
  # @example_response
  #   ```json
  #   {
  #     "payload": {
  #       "50 First Dates": {
  #         "title": "50 First Dates",
  #         "actors": [
  #           "Adam Sandler",
  #           "Drew Barrymore",
  #           "Rob Schneider"
  #         ],
  #         "locations": [{
  #           "name": "Rainforest Cafe (145 Jefferson Street)",
  #           "city": "San Francisco",
  #           "latitude": 37.8080708,
  #           "longitude": -122.4146114
  #         }],
  #         "writers": [
  #           "George Wing"
  #         ],
  #         "directors": [
  #           "Peter Segal"
  #         ],
  #         "fun_facts": "",
  #         "release_year": 2004,
  #         "production_company": "Columbia Pictures Corporation",
  #         "distributor": "Columbia Pictures"
  #       }
  #     },
  #     "meta": null
  #   }
  #   ```
  #
  def index
    puts "INDEX"
    payload = MovieService.all
    status = :ok
    meta = nil
    if payload.blank?
      status = 400
      meta = { message: 'Not Found' }
    end
    render json: { payload: payload, meta: meta },
           status: status
  end

  # @url /movies
  #
  # @action GET
  #
  # Get all the movies matching the search criteria
  #
  # @response [JSON]
  #
  # @example_request_description Lets get movies whose title starts with 40
  # @example_request GET /movies/search/40
  # @example_response_description Get all the matching movies
  # @example_response
  #   ```json
  #   {
  #     "payload": {
  #       "40 Days and 40 Nights": {
  #         "title": "40 Days and 40 Nights",
  #         "actors": [
  #           "Josh Hartnett",
  #           "Shaynnyn Sossamon"
  #         ],
  #         "locations": [
  #           {
  #             "name": "The Walden House, Buena Vista Park",
  #             "city": "San Francisco",
  #             "latitude": 37.7749295,
  #             "longitude": -122.4194155
  #           },
  #           {
  #             "name": "Cafe Trieste (609 Vallejo)",
  #             "city": "San Francisco",
  #             "latitude": 37.7749295,
  #             "longitude": -122.4194155
  #           }
  #         ],
  #         "writers": [
  #           "Robert Perez"
  #         ],
  #         "directors": [
  #           "Michael Lehmann"
  #         ],
  #         "fun_facts": "Francis Ford Coppola allegedly wrote...",
  #         "release_year": 2002,
  #         "production_company": "Miramax Films",
  #         "distributor": "Miramax Films"
  #       }
  #     },
  #     "meta": null
  #   }
  #   ```
  #
  def search
    puts "SEARCH"
    meta = { message: 'Not Found' }
    status = 400
    payload = MovieService.search(params['query'])

    if payload.present?
      status = :ok
      meta = nil
    end
    render json: { payload: payload, meta: meta },
           status: status
  end

  # @url /movies
  #
  # @action GET
  #
  # Get the details of movie for the given title
  #
  # @required [String] title Title of the movie
  #
  # @response [JSON]
  #
  # @example_request_description Lets get the movie with title The Dead Pool
  # @example_request /movies/The Dead Pool
  # @example_response_description Get the details of The Dead Pool movie
  # @example_response
  #   ```json
  #   {
  #     "payload": {
  #       "The Dead Pool": {
  #         "title": "The Dead Pool",
  #         "actors": [
  #           "Josh Hartnett",
  #           "Shaynnyn Sossamon"
  #         ],
  #         "locations": [
  #           {
  #             "name": "The Walden House, Buena Vista Park",
  #             "city": "San Francisco",
  #             "latitude": 37.7749295,
  #             "longitude": -122.4194155
  #           },
  #           {
  #             "name": "Cafe Trieste (609 Vallejo)",
  #             "city": "San Francisco",
  #             "latitude": 37.7749295,
  #             "longitude": -122.4194155
  #           }
  #         ],
  #         "writers": [
  #           "Robert Perez"
  #         ],
  #         "directors": [
  #           "Michael Lehmann"
  #         ],
  #         "fun_facts": "Francis Ford Coppola allegedly wrote...",
  #         "release_year": 2002,
  #         "production_company": "Miramax Films",
  #         "distributor": "Miramax Films"
  #       }
  #     },
  #     "meta": null
  #   }
  #   ```
  #
  def show
    puts "SHOW"
    payload = MovieService.by_title(params['title'])
    status = :ok
    meta = nil
    if payload.blank?
      status = 400
      meta = { message: 'Not Found' }
    end
    render json: { payload: payload, meta: meta },
           status: status
  end

  def rebuild_cache
    puts "REBUILD"
    MovieService.rebuild_cache
    render json: { payload: nil, meta: nil }, status: :ok
  end
end
