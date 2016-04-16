class Actor < ActiveRecord::Base
  self.table_name = 'actors'
  attr_accessible :name
  has_belongs_to_many :movies
end
