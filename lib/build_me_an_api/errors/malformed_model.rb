module BuildMeAnApi
  class MalformedModel < StandardError
    def initialize(model_info)
      @model_info = model_info
    end
    def message
      "One of the models with the following info #{@model} is malformed please check your resource descriptor file."
    end
  end
end