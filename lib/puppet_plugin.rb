begin
require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end
require 'byebug'
require 'puppet_plugin/version'
require 'puppet_plugin/identify/plugin'