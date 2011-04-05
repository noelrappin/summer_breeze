$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'action_controller'
require 'rspec'
require 'rails'
require 'summer_breeze'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

class DummyController
end

class DummyConfig
  def root
    ''
  end
end

class DummyApplication
  def routes
  end
  
  def config
    DummyConfig.new
  end
end

module Rails
  def self.application
    ::DummyApplication.new
  end
end
