require "rspec/core/rake_task"

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

RSpec::Core::RakeTask.new
task :default => :spec

desc "Calculate letters count. Usage letters_count[56]"
task  :letters_count, :number do |t, args|
  require 'lib/problem1'
  puts Problem1.letters_count(args[:number].to_i)
end 

desc "Solve problem1 till letters_count_till[1000]"
task  :letters_count_till, :number do |t, args|
  require 'lib/problem1'
  number =  args[:number].to_i
  result =  (1..number).inject(0){|sum, n| sum + Problem1.letters_count(n) }
  puts result
end 

