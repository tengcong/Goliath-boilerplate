env = ENV['RACK_ENV'] ||= 'prod'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

Bundler.require :default, env
Goliath.env = env

class Application < Goliath::API
  def response(env)
    ::API.call(env)
  end
end

