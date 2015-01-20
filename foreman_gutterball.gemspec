require File.expand_path('../lib/foreman_gutterball/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_gutterball'
  s.version     = ForemanGutterball::VERSION
  s.authors     = ['Red Hat']
  s.email       = ['foreman-dev@googlegroups.com']
  s.homepage    = 'http://katello.org'
  s.summary     = 'Gutterball plugin for Foreman and Katello'
  s.description = 'Gutterball plugin for Foreman and Katello'

  s.files = Dir['{app,config,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'katello'

  s.add_development_dependency 'rubocop', '0.24.1'
  s.add_development_dependency 'rubocop-checkstyle_formatter'

end
