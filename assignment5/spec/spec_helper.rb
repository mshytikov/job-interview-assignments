# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper.rb"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
# 
#

ENV['RACK_ENV'] ||= 'test'

require_relative '../super_upload.rb'
require 'goliath/test_helper'


# Requires supporting ruby files with custom matchers and macros, etc,
# # in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].map {|f| require f}


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include Goliath::TestHelper, example_group: { file_path: /spec\/integration/ }
  config.include SuperUpload::TestHelper, example_group: { file_path: /spec\/integration/ }
end
