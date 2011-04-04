require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SummerBreeze
  
  describe Controller do
    
    let(:controller) { SummerBreeze::Controller.new(::DummyController, 
        SummerBreeze::Container.new) }
    
    it "adds a fixture" do
      controller.fixture("Name")
      controller.fixtures.should have(1).fixture
    end
    
  end
  
end