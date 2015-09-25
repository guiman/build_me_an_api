require 'spec_helper'

describe BuildMeAnApi::DatabaseConfiguration do
  it "must retrieve the proper database gem" do
    expect { BuildMeAnApi::DatabaseConfiguration.new("") }.to raise_error(BuildMeAnApi::MalformedDatabaseDSN)
    expect { BuildMeAnApi::DatabaseConfiguration.new("non-existing-database::memory:") }.to raise_error(BuildMeAnApi::MalformedDatabaseDSN)


    expect(BuildMeAnApi::DatabaseConfiguration.new("sqlite::memory:").adapter_gem).to eq "dm-sqlite-adapter"
    expect(BuildMeAnApi::DatabaseConfiguration.new("sqlite:///path/to/project.db").adapter_gem).to eq "dm-sqlite-adapter"
    expect(BuildMeAnApi::DatabaseConfiguration.new("mysql://user:password@hostname/database").adapter_gem).to eq "dm-mysql-adapter"
    expect(BuildMeAnApi::DatabaseConfiguration.new("postgres://user:password@hostname/database").adapter_gem).to eq "dm-postgres-adapter"
  end
end
