module SummerBreeze
  
  module BeforeAndAfter
      
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
    
    def run_afters(fixture)
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
  
end