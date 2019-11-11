# frozen_string_literal: true

require './lib/fresh_objects/version'

Gem::Specification.new do |s|
  s.name        = 'fresh_objects'
  s.version     = FreshObjects::VERSION
  s.summary     = 'Filtering algorithm that keeps track of object timestamps and only keeps the freshest version of each object.'

  s.description = <<-DESCRIPTION
    This library provides a simple algorithm for object filtering based on an object's timestamp.
    A master list of object ID's and timestamps are managed by this library and can be persisted
    (outside of this library) for picking up where you last left off.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.homepage    = 'https://github.com/bluemarblepayroll/fresh_objects'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3.8'

  s.add_dependency('objectable', '~>1')

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 12')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rubocop', '~>0.74.0')
  s.add_development_dependency('simplecov', '~>0.17.0')
  s.add_development_dependency('simplecov-console', '~>0.5.0')
end
