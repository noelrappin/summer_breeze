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
    
    it "can add a fixture" do
      container.fixture("DummyController##index.pagination_container")
      container.controllers.size.should == 1
      controller = container.controllers.first
      controller.klass.should == DummyController
      controller.fixtures.size.should == 1
      fixture = controller.fixtures.first
      fixture.action.should == "index"
      fixture.limit_to_selector.should == ".pagination_container"
    end
  end
  
end