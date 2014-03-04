class Season < ActiveRecord::Base
	belongs_to :TvShow
	has_many :episodes

  default_scope { order('created_at ASC') } 
end
