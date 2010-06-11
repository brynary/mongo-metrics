require "mongo_metrics/body_wrapper"

class MongoMetrics
  DB_NAME = "mongo_metrics"

  def initialize(app)
    @app        = app
    @db         = Mongo::Connection.new.db(DB_NAME)
    @collection = @db["requests"]
  end

  def call(env)
    status, headers, body = @app.call(env)

    body = BodyWrapper.new(body) do
      @collection.insert "foo" => "bar"
    end

    [status, headers, body]
  end

end
