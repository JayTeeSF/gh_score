require 'spec_helper'

describe Actor do
  describe "import" do
    let(:other_username) { "tenderlove" }
    let(:mini_username) { "mini" }

    it "should be idempotent" do
      initial_event_count = Event.count
      lambda do
        Actor.import mini_username, :responder => FileResponder
      end.should change(Actor, :count).by(1)
      Event.count.should eql( 1 )

      lambda do
        Actor.import mini_username, :responder => FileResponder
      end.should change(Actor, :count).by(0)
      Event.count.should eql( 1 )
    end

    it "should import events for multiple actors" do
      initial_event_count = Event.count
      lambda do
        Actor.import mini_username, :responder => FileResponder
        Actor.import other_username, :responder => FileResponder
      end.should change(Actor, :count).by(2)
      final_event_count = Event.count

      (final_event_count - initial_event_count).should be >= 2
    end

    it "should create an actor and her(/his) associated events" do
      initial_event_count = Event.count
      lambda do
        Actor.import mini_username, :responder => FileResponder
      end.should change(Actor, :count).by(1)
      final_event_count = Event.count

      (final_event_count - initial_event_count).should eql( 1 )
    end
  end
end
