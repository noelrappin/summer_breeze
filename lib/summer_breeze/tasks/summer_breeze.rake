namespace :summer_breeze do
  
  task :generate_fixtures => :environment do
    ENV["RAILS_ENV"] ||= 'test'
    require "#{Rails.root}/spec/javascripts/support/summer_breeze"
    SummerBreeze::Container.run
  end

end