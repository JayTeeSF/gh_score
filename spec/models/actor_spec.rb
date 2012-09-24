require 'spec_helper'

describe Actor do
  let(:username) { "JayTeeSF" }
  let(:mini_username) { "mini" }
  let(:other_username) { "tenderlove" }

  describe "import" do
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

  describe "score" do
    let(:event_actions) { Event::ACTION_SCORE_MAP.keys }
    let(:event_action_scores) { Event::ACTION_SCORE_MAP.values }
    let(:expected_total_score) { event_action_scores.reduce(:+) }
    let(:actor) { Actor.create(:name => mini_username) }
    let(:event_records) {
      event_actions.reduce([]) {|memo, event_action|
        memo << { 
          "created_at" => DateTime.now,
          "type" => event_action,
          "url" => "http://...",
        }
        memo
      }
    }

    context "with many events" do
      it "should total an actor's event-scores" do
        Event.create_for actor, :event_records => event_records
        actor.score.should eql( expected_total_score )
      end
    end

    context "with a single event" do
      it "should total an actor's event-scores" do
        _actor = Actor.import mini_username, :responder => FileResponder
        _actor.score.should eql( Event.last.score )
      end
    end
  end
end
