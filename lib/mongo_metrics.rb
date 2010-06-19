require "mongo_metrics/body_wrapper"

class MongoMetrics
  DB_NAME = "mongo_metrics"

  def initialize(app)
    require "mongo"

    @app        = app
    @db         = Mongo::Connection.new.db(DB_NAME)
    @collection = @db["requests"]
  end

  def call(env)
    request = Rack::Request.new(env)
    status, headers, body = @app.call(env)

    body = BodyWrapper.new(body) do
      @collection.insert "params" => request.params
    end

    [status, headers, body]
  end

end
