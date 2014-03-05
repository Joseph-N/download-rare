class Season < ActiveRecord::Base
	belongs_to :tv_show
	has_many :episodes, dependent: :destroy

  default_scope { order('created_at ASC') } 
end
