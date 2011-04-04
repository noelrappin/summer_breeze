require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


module SummerBreeze
  
  describe Container do
    
    let(:container) { SummerBreeze::Container.new }
    
    
    it "adds an initializer" do
      container.initializer(:init) { 3 }
      container.initializers.keys.should have(1).key
      container.initializers[:init].call.should == 3
    end
    
    it "adds a controller" do
      container.controller(DummyController) { 3 }
      container.controllers.size.should == 1
      container.controllers[0].is_a?(SummerBreeze::Controller).should be_true
    end
    
  end
  
end