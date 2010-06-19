class MongoMetrics
  class RequestDocument# < ::Hash
    attr_reader :env

    def initialize(env)
      @env = env
      record_env
    end

    def record_response(status)
      document["status"] = status
    end

    def to_hash
      document
    end

  private

    def record_env
      document["params"] = request.params
      record_cookies
    end

    def record_cookies
      return unless env["mongo_metrics.cookies"]
      document["cookies"] = Hash.new

      env["mongo_metrics.cookies"].each do |cookie_name|
        document["cookies"][cookie_name] = request.cookies[cookie_name]
      end
    end

    def document
      @hash ||= Hash.new
    end

    def request
      @request ||= Rack::Request.new(env)
    end

  end
end
