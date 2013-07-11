module BuildMeAnApi
  class MalformedDatabaseDSN < StandardError
    def initialize(dsn)
      @dsn = dsn
    end

    def message
      "The database dsn is malformed: #{@dsn} please check the provided parameters."
    end
  end
end