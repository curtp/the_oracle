module Oracle
  def self.config
    @config ||= begin
      YAML.load_file('config.yml'.freeze).symbolize_keys
    end
  end
end
