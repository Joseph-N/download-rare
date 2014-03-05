class Episode < ActiveRecord::Base
  belongs_to :season

  validates_presence_of :episode_number

  default_scope { order('created_at DESC') } 
end
