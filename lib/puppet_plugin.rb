begin
require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end
require 'byebug'
require 'pry'
require 'puppet_plugin/version'
require 'puppet_plugin/puppet/plugin'

I18n.load_path << File.expand_path('../templates/locales/en.yml', File.dirname(__FILE__))
