require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'app/channels/' 
  add_filter 'app/jobs/'
  add_filter 'app/mailers/'
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(merchant)
    return {
      provider: merchant.provider,
      uid: merchant.uid,
      info: {
        email: merchant.email,
        nickname: merchant.username
        # You can add more fields from
        # The omniauth hash here
      }
    }
  end

  def perform_login(merchant = Merchant.first)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    get auth_callback_path(:github)

    return merchant
  end
end
