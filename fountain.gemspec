$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'fountain/version'

Gem::Specification.new do |s|
  s.name = 'fountain'
  s.version = Fountain::VERSION
  s.author = 'Ian Unruh'
  s.email = 'ianunruh@gmail.com'
  s.license = 'MIT'
  s.homepage = 'https://github.com/ianunruh/fountain'
  s.description = 'Light framework for CQRS and event sourcing'
  s.summary = 'Light framework for CQRS and event sourcing'

  s.files = Dir['LICENSE', 'README.md', 'lib/**/*']
  s.test_files = Dir['spec/**/*']
  s.require_path = 'lib'

  s.add_dependency 'abstract_type'
  s.add_dependency 'activesupport'
  s.add_dependency 'adamantium'
  s.add_dependency 'equalizer'
  s.add_dependency 'thread_safe'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
