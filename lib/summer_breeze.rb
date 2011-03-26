require 'summer_breeze/before_and_after'
require 'summer_breeze/define'
require 'summer_breeze/container'
require 'summer_breeze/fixture'
require 'summer_breeze/controller'

module SummerBreeze
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "summer_breeze/tasks/summer_breeze.rake"
      end
    end
  end
end