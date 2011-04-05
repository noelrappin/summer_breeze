require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SummerBreeze
  
  describe Fixture do
  
    it "doesn't split a name without a selector" do
      fixture = Fixture.new("fixture", nil) 
      fixture.action.should == "fixture"
      fixture.limit_to_selector.should be_nil
    end
    
    it "splits a name with a class selector" do
      fixture = Fixture.new("fixture.class", nil) 
      fixture.action.should == "fixture"
      fixture.limit_to_selector.should == ".class"
    end
    
    it "splits a name with an id selector" do
      fixture = Fixture.new("fixture#dom_id", nil) 
      fixture.action.should == "fixture"
      fixture.limit_to_selector.should == "#dom_id"
    end
    
    it "ignores splitting the name if the action is set in the block" do
      fixture = Fixture.new("fixture", nil) { action("action") }
      fixture.action.should == "action"
    end
    
    it "adds an initializer " do
      fixture = Fixture.new("fixture", nil) 
      fixture.initialize_with(:thing)
      fixture.initializers.should == [:thing]
    end
    
    describe "the accessors" do
      
      let(:fixture) { Fixture.new("fixture", nil) }
      
      it "uses the getter with one arg as a setter" do
        fixture.action("fred")
        fixture.instance_variable_get("@action").should == "fred"
      end
      
      it "uses the getter with no args as a getter" do
        fixture.action("fred")
        fixture.action.should == "fred"
      end
      
      it "uses a getter with a block as a lazy setup" do
        sample = {}
        fixture.action { sample[:test] }
        sample[:test] = "nifty"
        fixture.action.should == "nifty"
      end
      
    end

    describe "running and such" do
      
      let(:fixture) { Fixture.new("fixture", nil) }
      
      it "describes the output path" do
        fixture.fixture_path.should == ""
      end
      
    end
    
    # def run_initializers
    #   initializers.each do |initializer|
    #     proc = initializer
    #     if initializer.is_a?(Symbol)
    #       proc = controller.container.initializers[initializer]
    #     end
    #     #note, should the actual run have it's own context?
    #     controller.instance_eval(&proc) if proc
    #   end
    # end
    # 
    # def call_controller
    #   controller.process(action, params, session, flash, method)
    # end
    # 
    # def run
    #   controller.reset
    #   Controller.run_befores(self.controller)
    #   Fixture.run_befores(self)
    #   run_initializers
    #   call_controller
    #   save_response
    #   Fixture.run_afters(self)
    #   Controller.run_afters(self.controller)
    # end
    # 
    # def fixture_path
    #   path = File.join(::Rails.root, 'tmp', 'summer_breeze')
    #   Dir.mkdir(path) unless File.exists?(path)
    #   path
    # end
    # 
    # def fixture_file
    #   File.join(fixture_path, "#{name}.html")
    # end
    # 
    # def html_document
    #   @html_document ||= Nokogiri::HTML(response_body)
    # end
    # 
    # def scrub_html_document
    #   remove_third_party_scripts(html_documen)
    #   convert_body_tag_to_div
    # end
    # 
    # def remove_third_party_scripts(doc)
    #   scripts = doc.at('#third-party-scripts')
    #   scripts.remove if scripts
    #   doc
    # end
    # 
    # def save_response
    #   File.open(fixture_file, 'w') do |f|
    #     f << scrubbed_response
    #   end
    # end
    # 
    # def response_body
    #   @response_body ||= controller.controller.response.body
    # end
    # 
    # def scrubbed_response
    #   result = html_document
    #   result = remove_third_party_scripts(result)
    #   result = result.css(limit_to_selector).first.to_s
    #   convert_body_tag_to_div(result)
    # end
    # 
    # def convert_body_tag_to_div(markup)
    #   markup.gsub("<body", '<div').gsub("</body>", "</div>")
    # end

  end
  
end