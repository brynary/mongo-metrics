class MongoMetrics
  class Options

    def self.valid_options
      [
        "mongo_metrics.cookies",
        "mongo_metrics.request_headers"
      ]
    end

    def initialize(customized_defaults = {}, env = {})
      update_options default_options
      update_options customized_defaults
      update_options env
    end

    def [](key)
      read_option(key)
    end

  private

    def values
      @values ||= Hash.new
    end

    def option_name(key)
      case key
      when Symbol ; "mongo_metrics.#{key}"
      when String ; key
      else raise ArgumentError
      end
    end

    def update_options(new_options)
      new_options.each do |key, value|
        next unless valid_option?(key)
        write_option(key, value)
      end
    end

    def valid_option?(key)
      self.class.valid_options.include?(option_name(key))
    end

    def read_option(key)
      values[option_name(key)]
    end

    def write_option(key, value)
      values[option_name(key)] = value
    end

    def default_options
      {
        "mongo_metrics.cookies" => ["__utma"],
        "mongo_metrics.request_headers" => []
      }
    end

  end
end
