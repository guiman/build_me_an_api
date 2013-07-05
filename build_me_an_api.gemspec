# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'build_me_an_api/version'

Gem::Specification.new do |spec|
  spec.name          = "build_me_an_api"
  spec.version       = BuildMeAnApi::VERSION
  spec.authors       = ["Álvaro F. Lara"]
  spec.email         = ["alvarola@gmail.com"]
  spec.description   = "A tool to build json apis easyly and with no pain."
  spec.summary       = "A tool to build json apis easyly and with no pain."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
