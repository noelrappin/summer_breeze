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
    
    attr_accessor :initializers, :fixtures
    
    def initialize
      @initializers = {}
      @fixtures = []
      SummerBreeze::Container.add_container(self)
    end
    
    def initializer(symbol, &block)
      initializers[symbol] = block
    end
    
    def fixture(name, &block)
      fixture = SummerBreeze::Fixture.new(name, self, &block)
      fixtures << fixture
    end
    
    def run
      fixtures.each { |fixture| fixture.run }
    end
    
  end
end
