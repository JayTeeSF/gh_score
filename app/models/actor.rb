class Actor < ActiveRecord::Base
  has_many :events
  attr_accessible :name

  def self.import username, options = {}
    find_or_create_by_name( username ).tap do |actor|
      Event.create_for actor, options
    end
  end

  def score
    events.map(&:score).reduce(:+)
  end
end
