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

require 'tmpdir'
require 'fileutils'
desc "Move documentation into gh-pages"
task :document do
  Dir.mktmpdir('documentarian') do |dir|
    FileUtils.cp_r('html', dir)
    system "git checkout gh-pages"
    FileUtils.cp_r(dir + '/html', 'html')
    system "git commit -am 'update documentation'"
  end
end

task :default => :test
