# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/twitterwatch/version'

Gem::Specification.new do |spec|
  spec.name          = 'cinch-twitterwatch'
  spec.version       = Cinch::Plugins::TwitterWatch::VERSION
  spec.authors       = ['Brian Haberer']
  spec.email         = ['bhaberer@gmail.com']
  spec.description   = %q{Cinch plugin that watches for new tweets from users.}
  spec.summary       = %q{Cinch Plugin to follow twitter.}
  spec.homepage      = 'https://github.com/bhaberer/cinch-twitterwatch'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler',          '~> 1.3'
  spec.add_development_dependency 'rake',             '~> 10.1'
  spec.add_development_dependency 'rspec',            '~> 2.14'
  spec.add_development_dependency 'coveralls',        '~> 0.7'
  spec.add_development_dependency 'cinch-test',       '~> 0.0', '>= 0.0.4'

  spec.add_dependency             'twitter',          '~> 5.7', '>= 5.7.1'
  spec.add_dependency             'cinch',            '~> 2',   '>= 2.0.12'
  spec.add_dependency             'cinch-toolbox',    '~> 1.1', '>= 1.1.2'
end
