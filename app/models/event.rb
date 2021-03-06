require 'digest/sha1'
class Event < ActiveRecord::Base
  ACTION_SCORE_MAP = {
    "CommitCommentEvent" => 2,
    "IssueCommentEvent" => 2,
    "IssuesEvent" => 3,
    "WatchEvent" => 1,
    "PullRequestEvent" => 5,
    "PushEvent" => 7,
    "FollowEvent" => 1,
    "CreateEvent" => 3,
  }
  # "ForkEvent" => 1, #unk
  DEBUG = nil

  belongs_to :actor
  attr_accessible :action, :checksum, :recorded_at, :url
  validates_uniqueness_of :checksum
  validates_presence_of :checksum
  validates_presence_of :action
  validates_presence_of :actor_id

  def self.create_for actor, options = {}
    event_records = options[ :event_records ] ||
      Github::Client.fetch( actor.name, options[ :responder ] )

    event_records.each do |event_record|
      new.tap do |event|
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
    end
  end

  def score
    ACTION_SCORE_MAP.fetch(action, 0)
  end
end
