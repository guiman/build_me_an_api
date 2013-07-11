module BuildMeAnApi
  class DatabaseConfiguration

    # accessors
    attr_reader :dsn

    def initialize(dsn)
      raise BuildMeAnApi::MalformedDatabaseDSN.new(dsn) unless dsn =~ /(sqlite|mysql|postgres):/
      @dsn = dsn
    end
    
    def adapter_gem
      "dm-#{@dsn.split(":").first}-adapter"
    end
  end
end
