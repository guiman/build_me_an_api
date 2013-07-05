module BuildMeAnApi
  class DatabaseConfiguration
    attr_reader :dsn
    def initialize(dsn)
      @dsn = dsn
    end
    
    def adapter_gem
      "dm-#{@dsn.split(":").first}-adapter"
    end
  end
end
