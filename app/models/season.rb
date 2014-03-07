class Season < ActiveRecord::Base
	belongs_to :tv_show, :touch => true
	has_many :episodes, dependent: :destroy

  default_scope { order('created_at ASC') } 
end
