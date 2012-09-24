require 'spec_helper'

describe Actor do
  describe "import" do
    let(:username) { "JayTeeSF" }
    let(:other_username) { "tenderlove" }

    it "should be idempotent" do
      initial_event_count = Event.count
      lambda do
        Actor.import username, :responder => FileResponder
      end.should change(Actor, :count).by(1)
      expected_final_event_count = Event.count

      (expected_final_event_count - initial_event_count).should be >= 1

      lambda do
        Actor.import username, :responder => FileResponder
      end.should change(Actor, :count).by(0)
      Event.count.should eql( expected_final_event_count )
    end

    it "should import events for mulitple actors" do
      initial_event_count = Event.count
      lambda do
        Actor.import username, :responder => FileResponder
        Actor.import other_username, :responder => FileResponder
      end.should change(Actor, :count).by(2)
      final_event_count = Event.count

      (final_event_count - initial_event_count).should be >= 2
    end

    it "should create an actor and her(/his) associated events" do
      initial_event_count = Event.count
      lambda do
        Actor.import username, :responder => FileResponder
      end.should change(Actor, :count).by(1)
      final_event_count = Event.count

      (final_event_count - initial_event_count).should be >= 1
    end
  end
end
