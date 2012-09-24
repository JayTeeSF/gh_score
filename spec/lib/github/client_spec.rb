require 'github/client'
require_relative '../../support/file_responder.rb'

describe "Github::Client" do
  let(:fixture_dir) { "#{File.dirname(__FILE__)}/../../fixtures" }
  let(:extension) { Github::Client::EXTENSION }

  describe "GET event stream" do
    context "without valid arguments" do
      it "should raise an exception" do
        expect {Github::Client.new}.to raise_error(ArgumentError)
        expect {Github::Client.fetch}.to raise_error(ArgumentError)
      end
    end

    context "with valid arguments" do
      let(:username) { "JayTeeSF" }
      let(:responder) { FileResponder }
      let(:other_username) { "tenderlove" }
      let(:raw_output) { File.read("#{fixture_dir}/#{username}#{extension}") }
      let(:other_raw_output) { File.read("#{fixture_dir}/#{other_username}#{extension}") }
      let(:parsed_output) { JSON.parse raw_output }
      let(:other_parsed_output) { JSON.parse other_raw_output }
      let(:expected_output) { parsed_output }
      let(:other_expected_output) { other_parsed_output }

      context "with one argument" do
        it "should not raise an exception" do
          gc = Github::Client.new username
          gc.should_receive(:raw_response).once.and_return([].to_json)
          expect {gc.fetch}.not_to raise_error
        end
      end

      context "with two arguments" do
        it "should not raise an exception" do
          gc = Github::Client.new username, responder
          gc.should_receive(:raw_response).once.and_return([].to_json)
          expect {gc.fetch}.not_to raise_error
        end

        it "should return the same github feed more than once" do
          first_got = Github::Client.fetch username, responder
          first_got.should eql( expected_output )

          then_got = Github::Client.fetch username, responder
          then_got.should eql( expected_output )
        end

        it "should (HTTP-)GET more than one github feed" do
          first_got = Github::Client.fetch username, responder
          first_got.should eql( expected_output )

          then_got = Github::Client.fetch other_username, responder
          then_got.should eql( other_expected_output )
        end

        it "should (HTTP-)GET a github feed" do
          got = Github::Client.fetch username, responder
          got.should eql( expected_output )
        end
      end
    end
  end

  describe "url" do
    let(:username) { "foo" }
    let(:extension) { ".json" }
    it "should yield a valid Github JSON url" do
      Github::Client.new(username).url.should eql( "#{Github::URL}/#{username}#{extension}" )
    end
  end
end
