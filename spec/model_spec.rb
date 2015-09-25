require 'spec_helper'

describe BuildMeAnApi::Model do
  let :raw_model do
    { "name" => "test_model", "attributes" => { "pk" => "id", "attr_str" => "string", "attr_nro" => "integer", "id" => "integer" } }
  end

  let :model do
    BuildMeAnApi::Model.new(raw_model)
  end

  it "throw an error with malfored data" do
    expect { BuildMeAnApi::Model.new({}) }.to raise_error(BuildMeAnApi::MalformedModel)
    expect { BuildMeAnApi::Model.new({ "name" => "test_model" }) }.to raise_error(BuildMeAnApi::MalformedModel)
    expect { BuildMeAnApi::Model.new({ "pk" => "id" }) }.to raise_error(BuildMeAnApi::MalformedModel)
    expect { BuildMeAnApi::Model.new({ "attributes" => "" }) }.to raise_error(BuildMeAnApi::MalformedModel)
  end

  it "must retrieve available attributes" do
    expected_attributes = { "attr_str" => "string", "attr_nro" => "integer", "id" => "integer" }

    expect(model.attributes).to eq expected_attributes
    expect(model.pk).to eq "id"
    expect(model.name).to eq "test_model"
  end

  it "must write a complete valid ruby class file" do
    base_file_path = File.dirname(__FILE__)

    model.write_file base_file_path

    expect(File.exist?(File.join(base_file_path, 'test_model.rb'))).to eq true

    # Test if it's valid ruby class
    valid_ruby_class = Proc.new do
      begin
        require 'data_mapper'
        require 'dm-sqlite-adapter'
        require File.join(base_file_path, 'test_model')

        DataMapper.setup :default, 'sqlite:memory:'
        DataMapper.auto_migrate!

        test_model_instance = TestModel.new(attr_nro: 10, attr_str: "this is a string")
        expect(test_model_instance.attr_nro).to eq 10
        expect(test_model_instance.attr_str).to eq "this is a string"
        expect(test_model_instance.id).to be_nil

        test_model_instance.save
        expect(test_model_instance.id).not_to be_nil

        true
      rescue Exception
        false
      end
    end.call

    expect(valid_ruby_class).to eq true

    File.delete(File.join(base_file_path, 'test_model.rb'))
    File.delete('memory:')
  end

  it "must be able to construct the class name" do
    expect(model.classname).to eq "TestModel"
  end
end
