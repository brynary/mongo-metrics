require "mongo_metrics/body_wrapper"
require "mongo_metrics/request_document"

class MongoMetrics
  DB_NAME = "mongo_metrics"
  COLLECTION_NAME = "requests"

  def initialize(app)
    require "mongo"

    @app        = app
    @db         = Mongo::Connection.new.db(DB_NAME)
    @collection = @db[COLLECTION_NAME]
  end

  def call(env)
    document = RequestDocument.new(env)
    status, headers, body = @app.call(env)
    [status, headers, body_wrapper(body, document)]
  end

private

  def body_wrapper(original_body, document)
    BodyWrapper.new(original_body) do
      @collection.insert(document.to_hash)
    end
  end

end
