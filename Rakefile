require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
desc 'Default: run the validates_as_hostname_label tests'
task :default => :test
 
desc 'Test the validates_as_hostname_label gem/plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end
 
desc 'Generate documentation for the validates_as_hostname_label gem/plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'validates_as_hostname_label'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end