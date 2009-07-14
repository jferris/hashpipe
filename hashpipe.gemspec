--- !ruby/object:Gem::Specification 
name: hashpipe
version: !ruby/object:Gem::Version 
  version: 0.0.5.0.1247583913
platform: ruby
authors: 
- Justin Leitgeb
autorequire: 
bindir: bin
cert_chain: []

date: 2009-07-14 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: wycats-moneta
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">"
      - !ruby/object:Gem::Version 
        version: 0.0.0
    version: 
- !ruby/object:Gem::Dependency 
  name: activesupport
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">"
      - !ruby/object:Gem::Version 
        version: 0.0.0
    version: 
description: HashPipe connects an AR-backed model to a key-value store
email: justin@phq.org
executables: []

extensions: []

extra_rdoc_files: []

files: 
- LICENSE
- Rakefile
- README.rdoc
- lib/hashpipe/archived_attribute.rb
- lib/hashpipe/global_configuration.rb
- lib/hashpipe.rb
- spec/hashpipe/archived_attribute_spec.rb
- spec/hashpipe/global_configuration_spec.rb
- spec/hashpipe_spec.rb
- spec/spec_helper.rb
- init.rb
- config/hashpipe.yml
has_rdoc: true
homepage: http://github.com/jsl/hashpipe
licenses: []

post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.4
signing_key: 
specification_version: 3
summary: ActiveRecord plugin to save content to a pluggable, hash-style backend
test_files: 
- spec/hashpipe/archived_attribute_spec.rb
- spec/hashpipe/global_configuration_spec.rb
- spec/hashpipe_spec.rb
- spec/spec_helper.rb
