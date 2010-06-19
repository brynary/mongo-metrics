class MongoMetrics
  class RequestDocument# < ::Hash

    def initialize(env)
      @env = env
    end

    def to_hash
      document = Hash.new
      document["params"] = request.params

      if @env["mongo_metrics.cookies"]
        document["cookies"] = Hash.new

        @env["mongo_metrics.cookies"].each do |cookie_name|
          document["cookies"][cookie_name] = request.cookies[cookie_name]
        end
      end

      document
    end

  private

    def request
      @request ||= Rack::Request.new(@env)
    end

  end
end
