require 'spec_helper'

describe BuildMeAnApi::DatabaseConfiguration do
  it "must retrieve the proper database gem" do
    Proc.new { BuildMeAnApi::DatabaseConfiguration.new("") }.must_raise BuildMeAnApi::MalformedDatabaseDSN
    Proc.new { BuildMeAnApi::DatabaseConfiguration.new("non-existing-database::memory:") }.must_raise BuildMeAnApi::MalformedDatabaseDSN

    BuildMeAnApi::DatabaseConfiguration.new("sqlite::memory:").adapter_gem.must_equal "dm-sqlite-adapter"
    BuildMeAnApi::DatabaseConfiguration.new("sqlite:///path/to/project.db").adapter_gem.must_equal "dm-sqlite-adapter"
    BuildMeAnApi::DatabaseConfiguration.new("mysql://user:password@hostname/database").adapter_gem.must_equal "dm-mysql-adapter"
    BuildMeAnApi::DatabaseConfiguration.new("postgres://user:password@hostname/database").adapter_gem.must_equal "dm-postgres-adapter"
  end
end