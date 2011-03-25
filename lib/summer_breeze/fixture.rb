module SummerBreeze
  class Fixture
    include ActionController::TestCase::Behavior
    
    class << self
      
      def before(&proc)
        @before_list ||= []
        @before_list << proc
      end
      
      def after(&proc)
        @after_list ||= []
        @after_list << proc
      end
      
      def run_befores(fixture)
        @before_list ||= []
        @before_list.each do |proc| 
          fixture.instance_eval(&proc)
        end
      end
      
      def run_afters
        @after_list ||= []
        @after_list.each { |proc| proc.call }
      end
      
      def setup(*methods)
        methods.each { |method| before { send method } }
      end

      def teardown(*methods)
        methods.each { |method| after { send method } }
      end
    end
    
    
    #include Devise::TestHelpers
    
    attr_accessor :name, :container, :initializer, :controller_class, :action, 
        :method, :limit_to_selector, :params
        

    def initialize(name, container, &initialize_block)
      @name = name
      @container = container
      instance_eval(&initialize_block)
    end 
    
    def initialize_with(symbol_or_proc)
      self.initializer = symbol_or_proc
    end
    
    [:controller_class, :action, :method, :limit_to_selector, :params].each do |sym|
      define_method(sym) do |new_value = :no_op|
        unless new_value == :no_op
          send(:"#{sym}=", new_value)
        end
        instance_variable_get("@#{sym}")
      end
    end
    
    def run_initializer
      proc = initializer
      if initializer.is_a?(Symbol)
        proc = container.initializers[initializer]
      end
      instance_eval(&proc) #note, should the actual run have it's own context?
    end
    
    def run
      Fixture.run_befores(self)
      run_initializer
      call_controller
      save_response
    ensure
      #Fixture.run_afters
    end

  end
end