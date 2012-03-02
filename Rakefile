#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'

desc "Run all our tests"
task :test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.pattern = "test/**/*_test.rb"
    t.verbose = false
  end
end

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  
  rdoc.rdoc_files.include("README.md","lib/**/*.rb")
end

task :default => :test
