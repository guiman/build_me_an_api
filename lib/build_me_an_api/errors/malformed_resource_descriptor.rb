module BuildMeAnApi
  class MalformedResourceDescriptor < StandardError
    def message
      "The resource descriptor is malformed please check your resource descriptor file."
    end
  end
end