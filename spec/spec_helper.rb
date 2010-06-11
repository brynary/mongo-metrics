require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift File.expand_path("../lib")
require "mongo_metrics"

require "rspec"
require "rack/test"

RSpec.configure do |c|
  c.include Rack::Test::Methods

  def app
    Fixture::Application
  end
end
