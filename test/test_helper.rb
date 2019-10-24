require "simplecov"

SimpleCov.start "rails" do
  add_filter "app/channels/"
  add_filter "app/models/"
  add_filter "app/jobs/"
  add_filter "app/mailers/"
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/test/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited to use the mock authentication hash.
    # A request to /auth/provider will redirect immediately to /auth/provider/callback.
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(merchant)
    return {
             provider: merchant.provider,
             uid: merchant.uid,
             info: {
               email: merchant.email,
               username: merchant.username,
             },
           }
  end

  def perform_login(merchant = nil)
    merchant ||= Merchant.first

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    get auth_callback_path(:github)

    return merchant
  end

  # Add more helper methods to be used by all tests here...
end
