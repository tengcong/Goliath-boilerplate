Pry.config.editor = "gvim --nofork"

env = 'development'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

Bundler.require :default, env

Dir["./config/initializers/*.rb"].each { |f| require f }
Dir["./app/models/*.rb"].each { |f| require f }


