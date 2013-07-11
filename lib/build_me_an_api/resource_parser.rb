module BuildMeAnApi
  class ResourceParser
    attr_reader :models

    def initialize(resource_file)
      @file = resource_file
    end
    
    def load
      @resources_raw_data = JSON.load(File.read(@file))

      unless @resources_raw_data["resources"] && @resources_raw_data["resources"].instance_of?(Array)
        @resources_raw_data = nil

        raise BuildMeAnApi::MalformedResourceDescriptor.new
      end
    end

    def parse
      load

      @models = @resources_raw_data["resources"].inject([]) { |col, raw_model| col << Model.new(raw_model) }

      self
    end
  end
end
