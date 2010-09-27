require "mongo_metrics/options"
require "mongo_metrics/request_document"
require "mongo"

class MongoMetrics
  DB_NAME = "mongo_metrics"
  COLLECTION_NAME = "requests"

  @@db = Mongo::Connection.new.db(DB_NAME)

  def initialize(app, customized_defaults = {})
    @app                  = app
    @customized_defaults  = customized_defaults
    @collection           = @@db[COLLECTION_NAME]
  end

  def call(env)
    document = RequestDocument.new(@customized_defaults, env)
    status, headers, body = @app.call(env)
    document.record_response(status)

    @collection.insert(document.to_hash)

    [status, headers, body]
  end

end
