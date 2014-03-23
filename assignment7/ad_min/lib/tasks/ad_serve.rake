namespace :ad_serve do

  desc "Test AdServe"
  Rake::TestTask.new(:test) do |t|
    t.libs << "test"
    t.test_files = ['test/lib/ad_serve_test.rb']
  end

end

# Test AdServe when callling `rake test`
Rake::Task[:test].enhance { Rake::Task["ad_serve:test"].invoke }
