namespace :summer_breeze do
  
  task :generate_fixtures do
    Rails.env = 'test'
    require File.expand_path("#{Rails.root}/config/environment", __FILE__)
    require "#{Rails.root}/spec/javascripts/support/summer_breeze"
    SummerBreeze::Container.run
  end

end