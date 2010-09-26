require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift File.expand_path("../lib")
require "mongo_metrics"

require "rspec"
require "rack/test"

ENV["RAILS_ENV"] = "test"
require "fixture/config/environment"

RSpec.configure do |c|
  c.include Rack::Test::Methods

  c.before do
    db.collections.each(&:drop)
  end

  def document
    requests_collection.find.to_a.last
  end

  def requests_collection
    @collection ||= db["requests"]
  end

  def db
    @db ||= mongo.db(MongoMetrics::DB_NAME)
  end

  def mongo
    @mongo ||= Mongo::Connection.new
  end

  def app
    Fixture::Application
  end
end
