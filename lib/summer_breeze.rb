require 'summer_breeze'
require 'rails'
p "loading"
module SummerBreeze
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "summer_breeze/tasks/summer_breeze.rake"
      end
    end
  end
end