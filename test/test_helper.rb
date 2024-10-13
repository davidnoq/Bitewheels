# test/test_helper.rb

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'devise'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # Comment out the fixtures line to disable fixture loading
  # fixtures :all

  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
end
