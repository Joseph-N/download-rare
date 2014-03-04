class Episode < ActiveRecord::Base
  belongs_to :season

  validates_presence_of :episode_number
end
