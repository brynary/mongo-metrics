class MongoMetrics
  class BodyWrapper
    def initialize(body, &close_callback)
      @body = body
      @close_callback = close_callback
    end

    def each(&callback)
      @body.each(&callback)
    end

    def close
      @body.close if @body.respond_to?(:close)
      @close_callback.call if @close_callback
    end
  end
end
