require 'digest/sha1'
class Actor < ActiveRecord::Base
  DEBUG = nil
  attr_accessible :name

  def self.import username, options = {}
    actor = find_or_create_by_name username
    event_records = Github::Client.fetch username, options[ :responder ]
    event_records.each do |event_record|
      event = Event.new
      event.actor = actor

      # mapping(s):
      event.recorded_at = event_record["created_at"]
      event.action = event_record["type"]

      event.url = event_record["url"]

      event.body = event_record.to_json
      event.checksum = Digest::SHA1.hexdigest event.body
      if event.valid?
        puts "event is valid..." if DEBUG
        event.save
      else
        puts event.errors.to_a.inspect if DEBUG
      end
    end
    actor
  end
end
