# @restful_api 1.0
#
# @property [String] title Title of the movie
# @property [Array<Actor>] actors List of actors in this movie
# @property [Array<Location>] locations List of locations where the movie was shot
# @property [Array<Director>] directors List of directors of the movie
# @property [Array<Writer>] writers List of writers of the movie
# @property [Integer] release_year Year of release
# @property [String] production_company Production Company
# @property [String] fun_facts Funny moments
# @property [String] distributor Distributor Company of the movie
#
#
# @example
# ```json
# {
#   "payload": {
#     "40 Days and 40 Nights": {
#       "title": "40 Days and 40 Nights",
#       "actors": [
#         "Josh Hartnett",
#         "Shaynnyn Sossamon"
#       ],
#       "locations": [
#         {
#           "name": "The Walden House, Buena Vista Park",
#           "city": "San Francisco",
#           "latitude": 37.7749295,
#           "longitude": -122.4194155
#         },
#         {
#           "name": "Cafe Trieste (609 Vallejo)",
#           "city": "San Francisco",
#           "latitude": 37.7749295,
#           "longitude": -122.4194155
#         }
#       ],
#       "writers": [
#         "Robert Perez"
#       ],
#       "directors": [
#         "Michael Lehmann"
#       ],
#       "fun_facts": "Francis Ford Coppola allegedly wrote...",
#       "release_year": 2002,
#       "production_company": "Miramax Films",
#       "distributor": "Miramax Films"
#     }
#   },
#   "meta": null
# }
# ```
class Movie < ActiveRecord::Base
  self.table_name = 'movies'

  enum status: { active: 'active', inactive: 'inactive', deleted: 'deleted' }
  attr_accessible :title, :actors, :locations, :release_year,
                  :production_company, :fun_facts, :writers,
                  :directors, :created_at, :updated_at, :status,
                  :distributor

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :writers
  has_and_belongs_to_many :directors
  has_and_belongs_to_many :locations

  validates :title, uniqueness: true, presence: true
end
