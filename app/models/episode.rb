class Episode < ActiveRecord::Base
  belongs_to :season, :touch => true
  has_many :download_links, dependent: :destroy

#  validates_presence_of :episode_number

  default_scope { order('updated_at DESC') } 
end
