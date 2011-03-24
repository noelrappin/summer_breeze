p "file"

task :aaa do 
  p "I'm a test"
end

namespace :summer_breeze do
  
  task :generate_fixtures => :environment do
    p "fred"
  end

end