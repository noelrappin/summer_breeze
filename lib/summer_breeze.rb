require 'summer_breeze'
require 'rails'
p "loading 2"
module SummerBreeze
  module Rails
    class Railtie < ::Rails::Railtie
      p "in class"
      rake_tasks do
        p "in block"
        load "summer_breeze/tasks/summer_breeze.rake"
      end
    end
  end
end