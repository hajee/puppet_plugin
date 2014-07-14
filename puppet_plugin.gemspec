# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_plugin/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet_plugin"
  spec.version       = PuppetPlugin::VERSION
  spec.authors       = ["Bert Hajee"]
  spec.email         = ["hajee@moretIA.com"]
  spec.summary       = %q{Identify yourself as a puppet host and run the according manisfest}
  spec.description   = %q{Identify yourself as a puppet host and run the according manisfest}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
