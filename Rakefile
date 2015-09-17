require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'bundler'
require 'simplecov'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "google_authenticator_auth 1.0.1"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('MIT-LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
end

task :default => :test