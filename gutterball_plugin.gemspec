$:.push File.expand_path("../lib", __FILE__)

require "gutterball_plugin/version"

Gem::Specification.new do |s|
  s.name        = "gutterball_plugin"
  s.version     = GutterballPlugin::VERSION
  s.authors     = ["Red Hat"]
  s.email       = ["foreman-dev@googlegroups.com"]
  s.homepage    = "http://katello.org"
  s.summary     = "Katello Gutterball Plugin"
  s.description = "Katello Gutterball Plugin"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "katello"

end
