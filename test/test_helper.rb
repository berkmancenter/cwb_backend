ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'action_controller/test_case'

require File.expand_path('../../lib/cwb', __FILE__)
require File.expand_path('../../lib/cwb/pim', __FILE__)

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end

class MockCWB
  class << self
    attr_reader :calls

    def sparql(*args)
      @calls = []
      return self
    end

    def method_missing(method, *args)
      @calls << method
    end
  end
end
