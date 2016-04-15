class Movie < ActiveRecord::Base
  self.table_name = 'movies'

  as_enum :status_enum,
    [:active, :inactive, :deleted],
    strings: true,
    column: :status

  attr_accessible :title, :actors, :locations, :release_year, 
		  :production_company, :fun_facts, :writers,
		  :directors, :created_at, :updated_at, :status,
		  :distributor

  has_many :actors, class_name: 'Actor'
  has_many :writers, class_name: 'Writer'
  has_many :directors, class_name: 'Director'

end
