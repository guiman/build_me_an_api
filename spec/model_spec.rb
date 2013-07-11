require 'spec_helper'

describe BuildMeAnApi::Model do
  let :raw_model do
    { "name" => "test_model", "attributes" => { "pk" => "id", "attr_str" => "string", "attr_nro" => "integer", "id" => "integer" } }
  end
  
  let :model do
    BuildMeAnApi::Model.new(raw_model)
  end
  
  it "throw an error with malfored data" do
    Proc.new { BuildMeAnApi::Model.new({}) }.must_raise BuildMeAnApi::MalformedModel
    Proc.new { BuildMeAnApi::Model.new({ "name" => "test_model" }) }.must_raise BuildMeAnApi::MalformedModel
    Proc.new { BuildMeAnApi::Model.new({ "pk" => "id" }) }.must_raise BuildMeAnApi::MalformedModel
    Proc.new { BuildMeAnApi::Model.new({ "attributes" => "" }) }.must_raise BuildMeAnApi::MalformedModel
  end

  it "must retrieve available attributes" do
    expected_attributes = { "attr_str" => "string", "attr_nro" => "integer", "id" => "integer" }

    model.attributes.must_equal expected_attributes
    model.pk.must_equal "id"
    model.name.must_equal "test_model"
  end

  it "must write a complete valid ruby class file" do
    base_file_path = File.dirname(__FILE__)

    model.write_file base_file_path

    File.exist?(File.join(base_file_path, 'test_model.rb')).must_equal true

    # Test if it's valid ruby class
    Proc.new do
      begin
        require 'data_mapper'
        require 'dm-sqlite-adapter'
        require File.join(base_file_path, 'test_model')

        DataMapper.setup :default, 'sqlite:memory:'
        DataMapper.auto_migrate!

        test_model_instance = TestModel.new(attr_nro: 10, attr_str: "this is a string")
        test_model_instance.attr_nro.must_equal 10
        test_model_instance.attr_str.must_equal "this is a string"
        test_model_instance.id.must_be_nil

        test_model_instance.save
        test_model_instance.id.wont_be_nil

        true
      rescue Exception => e
        false
      end
    end.call.must_equal true

    File.delete(File.join(base_file_path, 'test_model.rb'))
  end
  
  it "must be able to construct the class name" do
    model.classname.must_equal "TestModel"
  end
end
