ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module AuthenticationTestHelper
  def sign_in_as_admin
    user = User.create!(
      name: "Admin de prueba",
      email: "admin-#{self.class.name.underscore}-#{object_id}@example.com",
      password: "password",
      role: "admin"
    )

    post admin_login_path, params: {
      email: user.email,
      password: "password"
    }
  end

  def sign_in_as_artist
    user = User.create!(
      name: "Artista de prueba",
      email: "artist-#{self.class.name.underscore}-#{object_id}@example.com",
      password: "password",
      role: "artist"
    )

    post artist_login_path, params: {
      email: user.email,
      password: "password"
    }

    user
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationTestHelper
end
