require 'spec_helper'

describe Event do
  describe "initialization" do
    context "without required params" do
      let(:event) { Event.new }
      let(:action_event) {
        Event.new.tap do |event|
          event.action = "blah"
        end
      }
      let(:checksum_event) {
        Event.new.tap do |event|
          event.checksum = "111"
        end
      }
      let(:actor_event) {
        Event.new.tap do |event|
          event.actor_id = 1
        end
      }
      it "should not be valid" do
        action_event.should_not be_valid
        actor_event.should_not be_valid
        checksum_event.should_not be_valid
        event.should_not be_valid
      end
    end

    context "with required params" do
      let(:event) {
        Event.new.tap do |event|
          event.actor_id = 1
          event.action = "blah"
          event.checksum = "111"
        end
      }
      let(:event_with_same_checksum) {
        Event.new.tap do |event|
          event.actor_id = 2
          event.action = "blah"
          event.checksum = "111"
        end
      }
      context "with a unique checksum" do
        it "should be valid" do
          event.should be_valid
        end
      end
      context "with an existing checksum" do
        it "should not be valid" do
          event.save!
          event_with_same_checksum.should_not be_valid
        end
      end
    end
  end

  describe "score" do
    let(:event_actions) { Event::ACTION_SCORE_MAP.keys }
    let(:event) {
      Event.new.tap do |event|
        event.actor_id = 2
        event.checksum = "111"
      end
      }

    it "should score by action" do
      event_actions.each do |action|
        event.action = action
        event.score.should eql( Event::ACTION_SCORE_MAP[action] )
      end
    end
  end
end
