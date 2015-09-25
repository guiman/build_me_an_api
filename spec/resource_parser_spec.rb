require 'spec_helper'

describe BuildMeAnApi::ResourceParser do
  it "must receive a valid resource file" do
    resource_parser = BuildMeAnApi::ResourceParser.new(File.join(File.dirname(__FILE__), 'files', 'non_valid_resource_descriptor.json'))
    expect { resource_parser.parse }.to raise_error(BuildMeAnApi::MalformedResourceDescriptor)

    resource_parser = BuildMeAnApi::ResourceParser.new(File.join(File.dirname(__FILE__), 'files', 'valid_resource_descriptor.json'))
    expect(resource_parser.parse.models.count).to eq 2
    resource_parser.parse.models.each { |model| expect(model).to be_a_kind_of BuildMeAnApi::Model }
  end
end
