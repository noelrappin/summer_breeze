module SummerBreeze
  class Controller
    extend SummerBreeze::BeforeAndAfter
    include ActionController::TestCase::Behavior
    include Devise::TestHelpers
    
    attr_accessor :fixtures, :klass, :container, :controller
    
    def initialize(klass, container, &block)
      @klass = klass
      @container = container
      @fixtures = []
      @controller = klass.new
      @routes = ::Rails.application.routes
      instance_eval(&block)
      self
    end
    
    def fixture(name, &block)
      fixtures << SummerBreeze::Fixture.new(name, self, &block)
    end
    
    def run
      fixtures.each { |fixture| fixture.run }
    end
  
  end
end