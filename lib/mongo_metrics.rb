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
    @queue                = []
    @lock                 = Mutex.new

    Thread.new do
      loop do
        documents = nil

        @lock.synchronize do
          if @queue.any?
            documents = @queue.dup
            @queue = []
          end
        end

        if documents
          @collection.insert(documents.map(&:to_hash))
        end

        sleep 0.001
      end
    end
  end

  def call(env)
    document = RequestDocument.new(@customized_defaults, env)
    status, headers, body = @app.call(env)
    document.record_response(status)

    @lock.synchronize do
      @queue << document
    end

    [status, headers, body]
  end

end
