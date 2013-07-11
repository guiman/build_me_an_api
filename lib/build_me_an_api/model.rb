module BuildMeAnApi
  class Model
    attr_reader :pk, :name, :attributes
    def initialize(raw_model)
      raise BuildMeAnApi::MalformedModel.new(raw_model) unless raw_model["name"] && raw_model["attributes"] && raw_model["attributes"]["pk"]

      @pk = raw_model["attributes"].delete("pk")
      @name = raw_model["name"]
      @attributes = raw_model["attributes"]
    end
    
    def write_file(file_path)
      model_file = File.new File.join(file_path, "#{@name}.rb"), 'w'

      model_file << "class #{classname}\n"
      model_file << "  include DataMapper::Resource\n\n"
      model_file << "  property :#{@pk}, Serial\n"

      @attributes.each { |k,v| model_file << "  property :#{k}, #{v.capitalize}\n" unless k == @pk }

      model_file << "end\n"
      model_file.close
    end
    
    def classname
      @name.split("_").map { |name| name.capitalize}.join("")
    end
  end
end
