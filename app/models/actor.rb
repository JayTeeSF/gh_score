class Actor < ActiveRecord::Base
  attr_accessible :name

  def self.import username, options = {}
    find_or_create_by_name( username ).tap do |actor|
      Event.create_for actor, options
    end
  end
end
