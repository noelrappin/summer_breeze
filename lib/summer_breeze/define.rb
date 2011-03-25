module SummerBreeze
  
  def self.define(&block)
    container = SummerBreeze::Container.new
    container.instance_eval(&block)
  end
  
end