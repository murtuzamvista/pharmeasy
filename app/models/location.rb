class Location < ActiveRecord::Base
  self.table_name = 'locations'
  attr_accessible :name, :latitude, :longitude, :city
  has_and_belongs_to_many :movies

  validates :name, uniqueness: true, presence: true

  before_save :geometry

  private

  def geometry
    google_config = $APP_CONFIG['google_maps']
    url = "#{google_config['url']}json?address=#{self.name.gsub '&', 'and'}+#{self.city}&key=#{google_config['api_key']}"
    url = URI.extract(URI.encode(url))[0]
    puts "URL==", url
    # TODO: check for errors/zero results in response
    response = JSON.parse(RestClient.get(url))['results'][0]['geometry']['location']
    self.latitude = response['lat']
    self.longitude = response['lng']
  end
end
