ENV['RACK_ENV'] = 'test'
require 'capybara/rspec'
require './app/app.rb'
require 'database_cleaner'
require 'features/web_helper'
require 'coveralls'
require 'simplecov'

Capybara.app = Chitter

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
Coveralls.wear!

RSpec.configure do |config|

  config.before(:each) do
    DataMapper.setup(:default, "postgres://localhost/bookmark_manager_test")
  end

  config.after(:each) do
    DataMapper.setup(:default, "postgres://localhost/bookmark_manager_development")
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|

    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups


end
