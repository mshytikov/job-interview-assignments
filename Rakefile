require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new
task :default => :spec

task :solve, [:url] do |t, args|
  require 'assignment1'
  raise "Please specify url of website" unless args.url
  puts "Crawls a #{args.url}:"
  puts "Deep: 3, Max pages: 50"
  Assignment1.solve(args.url) do |node|
    puts "#{node.id} - #{node.inputs_count + node.children_inputs_count}"
  end
end
