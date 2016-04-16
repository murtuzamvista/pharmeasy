class Director < ActiveRecord::Base
  self.table_name = 'directors'
  attr_accessible :name
  has_and_belongs_to_many :movies
  validates :name, uniqueness: true, presence: true
end
