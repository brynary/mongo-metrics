require "action_dispatch"

class MongoMetrics
  class RequestDocument
    attr_reader :env, :options

    include ::ActionDispatch::Http::FilterParameters

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
      document["params"]          = filtered_parameters
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
      document["request"]["headers"] ||= Hash.new

      options[:request_headers].each do |header_name|
        env_key = header_name.upcase.gsub("-", "_")
        env_key = "HTTP_" + env_key unless "CONTENT_TYPE" == env_key
        document["request"]["headers"][header_name] = @env[env_key]
      end

      document["request"]["session"] ||= Hash.new

      options[:session_keys].each do |session_key|
        document["request"]["session"][session_key] = @env["rack.session"][session_key]
      end

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

    def parameters
      request.params
    end

    def request
      @request ||= Rack::Request.new(env)
    end

  end
end
