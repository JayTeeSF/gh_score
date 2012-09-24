class Event < ActiveRecord::Base
  belongs_to :actor
  attr_accessible :action, :checksum, :recorded_at, :url
  validates_uniqueness_of :checksum
end
