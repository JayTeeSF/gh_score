require "open-uri"
require 'openssl'
require 'net/https'
require 'uri'
require "json"

module Github
  URL = 'https://github.com'
  class Client
    EXTENSION = ".json"
    def self.fetch username
      new(username).get
    end

    attr_reader :username
    def initialize username
      @username = username
    end

    def get
      JSON.parse response
    end

    def url
      "#{URL}/#{username}#{EXTENSION}"
    end

    private

    def response
      if RUBY_PLATFORM == "java"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request)
        response.body
      else
        open url
      end
    end
  end
end
