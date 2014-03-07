require 'bundler'

require 'rspec/core/rake_task'

task :default => [:test]
task :test => [:spec]

desc "run spec tests"
RSpec::Core::RakeTask.new('spec') do |t|
    t.pattern = 'spec/**/*_spec.rb'
end

