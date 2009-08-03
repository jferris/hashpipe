require 'rubygems'
require 'spec'

require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Test the plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts  = ["--format", "specdoc", "--colour"]
  t.libs << 'lib'
  t.verbose = true
end

desc "Run all the tests"
task :default => :spec

desc 'Generate documentation for the hashpipe plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HashPipe'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

gem_spec = Gem::Specification.new do |s|
  s.name     = "hashpipe"
  s.version  = "0.0.5.0.#{Time.now.to_i}"
  s.summary  = "ActiveRecord plugin to save content to a pluggable, hash-style backend"
  s.email    = "justin@phq.org"
  s.homepage = "http://github.com/jsl/hashpipe"
  s.description = "HashPipe connects an AR-backed model to a key-value store"
  s.has_rdoc = true
  s.authors  = ["Justin Leitgeb"]
  s.files    = FileList['[A-Z]*', '{lib,spec}/**/*.rb', 'init.rb', 'config/hashpipe.yml']
  s.test_files = FileList['spec/**/*.rb']
  s.add_dependency("jferris-moneta", ["> 0.0.0"])
  s.add_dependency("activesupport", ["> 0.0.0"])
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end
