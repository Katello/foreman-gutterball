#!/usr/bin/env rake

# rubocop:disable Style/AndOr
require 'rubocop/rake_task' and RuboCop::RakeTask.new

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ForemanGutterball'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Bundler::GemHelper.install_tasks
# APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
# load 'rails/tasks/engine.rake'

# require 'rake/testtask'
#
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end

task :default => :rubocop
