class BaseUrl < ActiveRecord::Base
  belongs_to :season
  validates_presence_of :url
  validates_uniqueness_of :url
end
