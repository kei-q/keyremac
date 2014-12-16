# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyremac/version'

Gem::Specification.new do |spec|
  spec.name          = "keyremac"
  spec.version       = Keyremac::VERSION
  spec.authors       = ["keqh"]
  spec.email         = ["keqh.keqh@gmail.com"]
  spec.description   = %q{KeyRemap4MacBook private.xml generator}
  spec.summary       = %q{KeyRemap4MacBook private.xml generator}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "builder"
end
