module SummerBreeze
  class Fixture
    extend SummerBreeze::BeforeAndAfter
    
    attr_accessor :name, :controller, :initializer, :controller_class, :action, 
        :method, :limit_to_selector, :params, :session, :flash
        

    def initialize(name, controller, &initialize_block)
      @name = name
      @controller = controller
      @params = {}
      @session = {}
      @flash = {}
      @method = "GET"
      instance_eval(&initialize_block) if block_given?
      parse_name
      self
    end 
    
    def parse_name
      return if action.present?
      self.action, self.limit_to_selector = name.split(/\.|#/)
    end
    
    def initialize_with(symbol_or_proc)
      self.initializer = symbol_or_proc
    end
    
    [:controller_class, :action, :method, :limit_to_selector, :params, :session, :flash].each do |sym|
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
        proc = controller.container.initializers[initializer]
      end
      instance_eval(&proc) if proc #note, should the actual run have it's own context?
    end
    
    def call_controller
      controller.process(action, params, session, flash, method)
    end
    
    def run
      Controller.run_befores(self.controller)
      Fixture.run_befores(self)
      run_initializer
      call_controller
      save_response
    # ensure
    #       p $1
    #       Fixture.run_afters(self)
    #       Controller.run_afters(self.controller)
    end
    
    def fixture_path
      path = File.join(::Rails.root, 'tmp', 'summer_breeze')
      Dir.mkdir(path) unless File.exists?(path)
      path
    end
    
    def fixture_file
      File.join(fixture_path, "#{name}.html")
    end
    
    def html_document
      @html_document ||= Nokogiri::HTML(response_body)
    end
    
    def scrub_html_document
      remove_third_party_scripts(html_documen)
      convert_body_tag_to_div
    end
    
    def remove_third_party_scripts(doc)
      scripts = doc.at('#third-party-scripts')
      scripts.remove if scripts
      doc
    end
    
    def save_response
      File.open(fixture_file, 'w') do |f|
        f << scrubbed_response
      end
    end
    
    def response_body
      @response_body ||= controller.controller.response.body
    end
    
    def scrubbed_response
      result = html_document
      result = remove_third_party_scripts(result)
      result = result.css(".#{limit_to_selector}").first.to_s
      convert_body_tag_to_div(result)
    end

    def convert_body_tag_to_div(markup)
      markup.gsub("<body", '<div').gsub("</body>", "</div>")
    end
    
  end
end