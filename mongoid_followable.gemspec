# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid_followable/version"

Gem::Specification.new do |s|
  s.name        = "mongoid_followable"
  s.version     = Mongoid::Followable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = "2011-07-04"
  s.authors     = ["Jie Fan"]
  s.email       = ["ustc.flyingfox@gmail.com"]
  s.homepage    = "https://github.com/lastomato/mongoid_followable"
  s.summary     = %q{ adds following feature to models }
  s.description = %q{ Please refer to http://rubygems.org/gems/mongo_followable for latest versions }

  s.rubyforge_project = "mongoid_followable"

  s.add_development_dependency("mongoid", "~> 2.0.1")
  s.add_development_dependency("bson_ext", "~> 1.3.0")
  s.add_development_dependency("database_cleaner", "~> 0.6")
  s.add_development_dependency("rspec", "~> 2.6")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
