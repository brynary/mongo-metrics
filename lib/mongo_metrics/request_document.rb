class MongoMetrics
  class RequestDocument
    attr_reader :env, :options

    def initialize(customized_defaults, env)
      @options = Options.new(customized_defaults, env)
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
      document["url"]             = request.url
      document["params"]          = request.params
      document["host"]            = request.host_with_port
      document["remote_ip"]       = request.ip
      document["request_method"]  = request.request_method
      document["url_scheme"]      = request.scheme
      document["path"]            = request.path
      document["user_agent"]      = request.user_agent
      record_cookies
    end

    def record_cookies
      return unless options[:cookies]
      document["cookies"] = Hash.new

      options[:cookies].each do |cookie_name|
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
