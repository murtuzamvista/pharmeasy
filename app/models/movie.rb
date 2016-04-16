class Movie < ActiveRecord::Base
  self.table_name = 'movies'

#  as_enum :status_enum,
#    [:active, :inactive, :deleted],
#    strings: true,
#    column: :status
  enum status: { active: 'active', inactive: 'inactive', deleted: 'deleted' }
  attr_accessible :title, :actors, :locations, :release_year, 
		  :production_company, :fun_facts, :writers,
		  :directors, :created_at, :updated_at, :status,
		  :distributor

  has_and_belongs_to_many :actors
  has_many :writers, class_name: 'Writer'
  has_many :directors, class_name: 'Director'

end
