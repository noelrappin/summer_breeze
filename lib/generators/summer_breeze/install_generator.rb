class SummerBreeze::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  def copy_files
    copy_file "summer_breeze.js", "spec/javascripts/helpers/summer_breeze.js"
    copy_file "summer_breeze.rb", "spec/javascripts/support/summer_breeze.rb"
  end
  
end
