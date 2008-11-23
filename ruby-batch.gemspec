Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
 
  s.name = 'ruby-batch'
  s.version = '0.1'
  s.date = "2008-11-23"
 
  s.description = "Simple batch frameork DSL"
  s.summary     = "Simple batch frameork DSL"
 
  s.authors = ["Bjørn Nordlund"]
 
  # = MANIFEST =
  s.files = %w[
    ChangeLog
    LICENSE
    README.rdoc
    Rakefile
  
    lib/ruby-batch.rb
    ruby-batch.gemspec
    test/printfile_test.rb
    test/test_helper.rb
  ]
  # = MANIFEST =
 
  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}
 
  s.extra_rdoc_files = %w[README.rdoc LICENSE]
  
  s.has_rdoc = true
  s.homepage = "http://ruby-batch.rubyforge.org"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby Batch", "--main", "README.rdoc"]
  s.require_paths = %w[lib]
  s.rubyforge_project = 'ruby-batch'
  s.rubygems_version = '1.1.1'
end