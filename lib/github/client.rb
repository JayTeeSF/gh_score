require "open-uri"
require 'openssl'
require 'net/https'
require 'uri'
require "json"

module Github
  URL = 'https://github.com'
  class Client
    DEBUG = nil
    module NetHttpResponder
      def raw_response
        puts "nethttp..." if self.class.const_get(:DEBUG)
        @raw_response ||= begin
                            uri = URI.parse(url)
                            http = Net::HTTP.new(uri.host, uri.port)
                            http.use_ssl = true
                            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                            request = Net::HTTP::Get.new(uri.request_uri)
                            http.request(request).body
                          end
      end
    end

    module OpenUrlResponder
      def raw_response
        puts "open..." if self.class.const_get(:DEBUG)
        @raw_response ||= begin
                            open( url ).read
                          end
      end
    end

    EXTENSION = ".json"

    def self.fetch username, responder = nil
      new(username, responder).fetch
    end

    attr_reader :username
    def initialize username, responder = nil
      unless responder
        responder = ( RUBY_PLATFORM == "java" ) ? NetHttpResponder : OpenUrlResponder
      end
      puts "including responder: #{responder.inspect}" if DEBUG
      extend responder
      @username = username
    end

    def fetch
      JSON.parse( raw_response )
    end

    def url
      "#{URL}/#{username}#{EXTENSION}"
    end
  end
end
