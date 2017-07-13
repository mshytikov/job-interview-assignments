require "rubygems"
require 'bundler'

require "bundler/setup"
Bundler.require(:default, ENV['RACK_ENV'].to_sym) #only load required gems

require_relative 'app/config'
require_relative 'app/calculation'
require_relative 'app/campaign'
require_relative 'app/routes'
