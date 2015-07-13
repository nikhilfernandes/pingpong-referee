require 'rubygems'




  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'  


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  
  #Dir[Rails.root.join("simulator/new_simulator.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods

    config.mock_with :rspec

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation      
      DatabaseCleaner.clean_with :truncation
    end

    config.after(:suite) do
      DatabaseCleaner.clean
    end

    config.before(:each) do
      DatabaseCleaner.start
    end


    config.after(:each) do
      DatabaseCleaner.clean
    end

  
    config.fixture_path = Rails.root.join('spec/fixtures')
  end

  

