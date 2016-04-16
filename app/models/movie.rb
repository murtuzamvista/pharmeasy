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
