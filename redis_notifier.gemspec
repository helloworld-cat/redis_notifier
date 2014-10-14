# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_notifier/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_notifier"
  spec.version       = RedisNotifier::VERSION
  spec.authors       = ["Sam"]
  spec.email         = ["samuel@pagedegeek.com"]
  spec.summary       = %q{Observe redis keyevent/keyspace and notify}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "Copyright Samuel"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.7'
end
