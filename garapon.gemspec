# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'garapon/version'

Gem::Specification.new do |spec|
  spec.name          = "garapon"
  spec.version       = Garapon::VERSION
  spec.authors       = ["hongo35"]
  spec.email         = ["s.style3.5@gmail.com"]
  spec.description   = "garapon TV API wrapper"
  spec.summary       = "garapon TV API wrapper"
  spec.homepage      = "https://github.com/hongo35/garapon"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "httpclient"
  spec.add_development_dependency "oj"
end
