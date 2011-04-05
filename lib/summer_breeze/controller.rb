module SummerBreeze
  class Controller
    extend SummerBreeze::BeforeAndAfter
    include ::ActionController::TestCase::Behavior
    
    begin
      include Devise::TestHelpers
    rescue
      nil
    end
    
    attr_accessor :fixtures, :klass, :container, :controller
    
    def initialize(klass, container, &block)
      @klass = klass
      @container = container
      @fixtures = []
      @controller = klass.new
      @routes = ::Rails.application.routes
      instance_eval(&block) if block
      self
    end
    
    def self.teardown_subscriptions
      ActiveSupport::Notifications.unsubscribe("render_template.action_view")
      ActiveSupport::Notifications.unsubscribe("!render_template.action_view")
    end
    
    def reset
      @controller = klass.new
    end
    
    def fixture(name, &block)
      fixtures << SummerBreeze::Fixture.new(name, self, &block)
    end
    
    def run
      fixtures.each { |fixture| fixture.run }
    end
  
  end
end