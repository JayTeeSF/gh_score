require 'github/client'
describe "Github::Client" do
  let(:fixture_dir) { "#{File.dirname(__FILE__)}/../../fixtures" }
  let(:extension) { Github::Client::EXTENSION }

  describe "GET event stream" do
    context "without valid arguments" do
      it "should raise an exception" do
        expect {Github::Client.fetch}.to raise_error(ArgumentError)
      end
    end

    context "with valid arguments" do
      let(:username) { "JayTeeSF" }
      let(:raw_output) { File.read("#{fixture_dir}/#{username}#{extension}") }
      let(:parsed_output) { JSON.parse raw_output }
      let(:expected_output) { parsed_output }

      before :each do
        # Mock network connection
        Github::Client.any_instance.should_receive(:response).and_return( raw_output )
      end

      it "should not raise an exception" do
        expect {Github::Client.fetch username}.not_to raise_error
      end

      it "should (HTTP-)GET a feed from github" do
        got = Github::Client.fetch username
        got.should eql( expected_output )
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
end
