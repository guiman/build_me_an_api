require 'spec_helper'

describe BuildMeAnApi::ResourceParser do
  it "must receive a valid resource file" do
    resource_parser = BuildMeAnApi::ResourceParser.new(File.join(File.dirname(__FILE__), 'files', 'non_valid_resource_descriptor.json'))
    Proc.new { resource_parser.parse }.must_raise BuildMeAnApi::MalformedResourceDescriptor

    resource_parser = BuildMeAnApi::ResourceParser.new(File.join(File.dirname(__FILE__), 'files', 'valid_resource_descriptor.json'))
    resource_parser.parse.models.count == 2
    resource_parser.parse.models.each { |model| (model.instance_of? BuildMeAnApi::Model).must_equal true }
  end
end
