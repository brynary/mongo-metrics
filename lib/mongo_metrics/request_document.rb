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

      if @env["action_dispatch.request.path_parameters"]
        document["controller_name"] = @env["action_dispatch.request.path_parameters"][:controller]
        document["action_name"] = @env["action_dispatch.request.path_parameters"][:action]
      end

      document["request"] ||= Hash.new
      document["request"]["content_type"] = request.content_type

      record_cookies
    end

    def record_cookies
      return unless options[:cookies]
      document["request"] ||= Hash.new
      document["request"]["cookies"] ||= Hash.new

      options[:cookies].each do |cookie_name|
        document["request"]["cookies"][cookie_name] = request.cookies[cookie_name]
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
