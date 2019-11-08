# frozen_string_literal: true

require './lib/timestampd/version'

Gem::Specification.new do |s|
  s.name        = 'timestampd'
  s.version     = Timestampd::VERSION
  s.summary     = 'Hash-based data structures and algorithms'

  s.description = <<-DESCRIPTION
    This library offers general purpose higher-level data structures that focus on Hash manipulation.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.homepage    = 'https://github.com/bluemarblepayroll/timestampd'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3.8'

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 12')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rubocop', '~>0.74.0')
  s.add_development_dependency('simplecov', '~>0.17.0')
  s.add_development_dependency('simplecov-console', '~>0.5.0')
end
