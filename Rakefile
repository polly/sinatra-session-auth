require 'rubygems'
require 'rake'
require "rake/testtask"

task :default => ["test"]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "sinatra-session-auth"
    gemspec.summary = "A orm-agnostic extension to add session based user authorization"
    gemspec.description = "sinatra-session-auth is an extension for Sinatra to add orm-agnostic session based user authorization"
    gemspec.email = "patrik@moresale.se"
    gemspec.homepage = "http://github.com/polly/sinatra-session-auth"
    gemspec.authors = ["Patrik Hedman"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
