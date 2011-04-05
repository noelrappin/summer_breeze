module SummerBreeze
  class Fixture
    extend SummerBreeze::BeforeAndAfter
    
    attr_accessor :name, :controller, :initializers, :controller_class, :action, 
        :method, :limit_to_selector, :params, :session, :flash
        

    def initialize(name, controller, &initialize_block)
      @name = name
      @controller = controller
      @params = {}
      @session = {}
      @flash = {}
      @method = "GET"
      @initializers = []
      instance_eval(&initialize_block) if block_given?
      parse_name
      self
    end 
    
    def parse_name
      return if action.present?
      result = name.match(/(.*)((\.|#).*)/)
      if result
        self.action = result[1] 
        self.limit_to_selector = result[2]
      else
        self.action = name
      end
    end
    
    def initialize_with(symbol_or_proc)
      self.initializers << symbol_or_proc
    end
    
    [:controller_class, :action, :method, :limit_to_selector, :params, :session, :flash].each do |sym|
      define_method(sym) do |new_value = :no_op, &block|
        unless new_value == :no_op
          send(:"#{sym}=", new_value)
          return 
        end
        if new_value == :no_op && block.present?
          send(:"#{sym}=", block)
          return 
        end
        result = instance_variable_get("@#{sym}")
        if result.is_a?(Proc)
          return result.call
        else
          return result
        end
      end
    end
    
    def run_initializers
      initializers.each do |initializer|
        proc = initializer
        if initializer.is_a?(Symbol)
          proc = controller.container.initializers[initializer]
        end
        #note, should the actual run have it's own context?
        controller.instance_eval(&proc) if proc
      end
    end
    
    def call_controller
      controller.process(action, params, session, flash, method)
    end
    
    def run
      controller.reset
      Controller.run_befores(self.controller)
      Fixture.run_befores(self)
      run_initializers
      call_controller
      save_response
      Fixture.run_afters(self)
      Controller.run_afters(self.controller)
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
      if limit_to_selector.present?
        result = result.css(limit_to_selector).first.to_s 
      else
        result = result.to_s
      end
      convert_body_tag_to_div(result)
    end

    def convert_body_tag_to_div(markup)
      markup.gsub("<body", '<div').gsub("</body>", "</div>")
    end
    
  end
end