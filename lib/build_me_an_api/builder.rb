module BuildMeAnApi
  class Builder
    def initialize(options)
      @api_name = options[:name]
      @database_configuration = DatabaseConfiguration.new(options[:dsn])
      @resource_descriptor = ResourceParser.new(options[:resources]).parse
    end
    
    def create_directories
      Dir.mkdir File.join('.', @api_name)
      Dir.mkdir File.join('.', @api_name, 'config')
      Dir.mkdir File.join('.', @api_name, 'model')
    end
    
    def write_template_gemfile
      gemfile_file = File.new File.join('.', @api_name, 'Gemfile'), 'w'
      gemfile_file << "source 'https://rubygems.org'\n"
      gemfile_file << "gem 'data_mapper', '~>1.2.0'\n"
      gemfile_file << "gem 'json', '~>1.8.0'\n"
      gemfile_file << "gem 'miniconfig', '~>0.0.1', github: 'patriciomacadden/miniconfig'\n"
      gemfile_file << "gem 'sinatra', '~>1.4.0'\n"
      gemfile_file << "gem '#{@database_configuration.adapter_gem}', '~>1.2.0'\n"
      gemfile_file << "group :test do\n"
      gemfile_file << "  gem 'minitest', '~>4.7.1', require: 'minitest/autorun'\n"
      gemfile_file << "  gem 'rake', '~>10.0.4'\n"
      gemfile_file << "end\n\n"

      gemfile_file.close
    end
    
    def write_config_ru
      config_ru_file = File.new File.join('.', @api_name, 'config.ru'), 'w'
      config_ru_file << "require 'bundler'\n"
      config_ru_file << "Bundler.require :default\n"
      config_ru_file << "require File.expand_path('api')\n"
      config_ru_file << "run App.new\n"

      config_ru_file.close
    end
    
    def write_database_configuration
      database_yml_file = File.new File.join('.', @api_name, 'config', 'database.yml'), 'w'
      database_yml_file << "dsn: '#{@database_configuration.dsn}'"
      database_yml_file.close
    end
    
    def write_models
      @resource_descriptor.models.each { |model| model.write_file File.join('.', @api_name) }
    end
    
    def write_main_api_file
      api_file = File.new File.join('.', @api_name, 'api.rb'), 'w'
      api_file << "# Models \n"

      @resource_descriptor.models.each do |model|
        api_file << "require_relative './model/#{model.name}' \n"
      end

      api_file << "database_config = Miniconfig.load('./config/database.yml') \n\n"
      api_file << "configure :development do \n"
      api_file << "  DataMapper::Logger.new('/tmp/datamapper_api.log', :debug) \n"
      api_file << "  DataMapper.setup(:default, database_config.dsn) \n"
      api_file << "  DataMapper.auto_upgrade!\n"
      api_file << "end\n\n"
      api_file << "class App < Sinatra::Base\n"
      api_file << "  before do\n"
      api_file << "    content_type 'application/json'\n"
      api_file << "  end\n"
      
      @resource_descriptor.models.each do |model|
        api_file << "
  get '/#{model.name}' do
    #{model.classname}.all.to_json
  end\n
  get '/#{model.name}/:#{model.pk}' do
    #{model.classname}.get(params[:#{model.pk}]).to_json
  end\n
  post '/#{model.name}' do
    #{model.classname}.create(params[:#{model.name}]).to_json
  end\n
  post '/#{model.name}/:#{model.pk}' do
    object = #{model.classname}.get(params[:#{model.pk}])
    object.update(params[:#{model.name}])
    object.to_json
  end\n"
      end

      api_file << "end\n\n"
      api_file.close
    end

    def write
      # First we create the directories
      create_directories

      # Then we write easy files
      ## Gemfile
      write_template_gemfile

      ## config.ru
      write_config_ru
      
      ## config/database.yml
      write_database_configuration
      
      # Now it's time for the fun stuff: Models
      write_models
      
      # Finally the file that contains the API < Sinatra::Base class
      write_main_api_file
    end
  end
end