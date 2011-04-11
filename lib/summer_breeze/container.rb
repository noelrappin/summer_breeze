module SummerBreeze
  class Container
    
    class << self
      
      def add_container(container)
        @containers ||= []
        @containers << container
      end
      
      def run
        @containers.each { |container| container.run }
      end
      
    end
    
    attr_accessor :initializers, :controllers
    
    def initialize
      @initializers = {}
      @controllers = []
      SummerBreeze::Container.add_container(self)
    end
    
    def initializer(symbol, &block)
      initializers[symbol] = block
    end
    
    def controller(klass, &block)
      controllers << SummerBreeze::Controller.new(klass, self, &block)
    end
    
    def run
      controllers.each { |controller| controller.run }
    end
    
    def fixture(name, &block)
      controller_name, fixture_name = name.split("##")
      controller = SummerBreeze::Controller.new(controller_name.constantize, self)
      controller.fixture(fixture_name, &block)
      controllers << controller
    end
    
  end
end
