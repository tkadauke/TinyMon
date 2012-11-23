# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.identifier = "org.tinymon.TinyMon"
  app.name = 'TinyMon'
  app.files = (app.files - Dir.glob('./app/**/*.rb')) + Dir.glob("./lib/**/*.rb") + Dir.glob("./app/**/*.rb")
  app.vendor_project('vendor/Reachability', :static)
  app.vendor_project('vendor/iOSPlot', :static)
  app.vendor_project('vendor/TVNavigationController', :static)
  
  app.detect_dependencies = false
  app.files_dependencies 'app/controllers/all_health_checks_view_controller.rb' => 'app/controllers/health_checks_view_controller.rb'
  app.files_dependencies 'app/controllers/check_run_log_entry_view_controller.rb' => 'app/controllers/html_view_controller.rb'
  
  app.pods do
    pod 'SVProgressHUD'
    pod 'ViewDeck', '1.4.2'
    pod 'TestFlightSDK', '1.1'
  end
  
  app.development do
    app.testflight do
      app.testflight.api_token = 'apitoken'
      app.testflight.team_token = 'teamtoken'
    end
  end
end

if File.exists?('devices.yml')
  namespace :device do
    YAML.load(File.read('devices.yml')).each do |name, id|
      desc "Deploy on #{name}"
      task name do
        sh "rake device id=#{id}"
      end
    end
  end
end
