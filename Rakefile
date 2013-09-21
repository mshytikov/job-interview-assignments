require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new
task :default => :spec

desc "Print output for Assignment2"
task :print do
  require 'assignment2'

  1.upto(100){|i| puts Assignment2.fizz_buzz(i) }
end
