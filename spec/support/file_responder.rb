module FileResponder
  def raw_response
    puts "reading file_for #{username.inspect}: #{file_for( username )}" if self.class.const_get(:DEBUG)
    @raw_response ||= begin
                        File.read( file_for( username ) )
                      end
  end

  private
  def file_for username
    "#{fixture_dir}/#{username}#{extension}"
  end

  def fixture_dir
    "#{File.dirname(__FILE__)}/../fixtures"
  end

  def extension
    Github::Client::EXTENSION
  end
end
