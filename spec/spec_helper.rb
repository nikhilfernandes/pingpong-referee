require 'rubygems'





  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'  
  require 'devise'



  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  


  RSpec.configure do |config|
    config.include Devise::TestHelpers, type: :controller
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

  

