module Moses
  class Config

    def initialize(file)
      @config = YAML.load_file(file)
    end

    def source_url
      connection_url_for('source')
    end

    def dest_url
      connection_url_for('destination')
    end

    private

    attr_reader :config

    def connection_url_for(key)
      conn = config[key]
      "#{conn['adapter']}://#{conn['username']}:#{conn['password']}@#{conn['host']}/#{conn['database']}"
    end

  end
end
