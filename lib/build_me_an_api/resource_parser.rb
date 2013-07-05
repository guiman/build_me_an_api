module BuildMeAnApi
  class ResourceParser
    attr_reader :models

    def initialize(resource_file)
      @resources_raw_data = JSON.load(File.read(resource_file))
    end

    def parse
      @models = @resources_raw_data["resources"].inject([]) { |col, raw_model| col << Model.new(raw_model) }

      self
    end
  end
end