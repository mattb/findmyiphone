# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{findmyiphone}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Biddulph"]
  s.date = %q{2009-07-23}
  s.description = %q{A toolkit for sending messages and getting location from MobileMe.}
  s.email = %q{matt@hackdiary.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "examples/fireeagle_keys.yml.example",
     "examples/iphone_2_fireeagle.rb",
     "examples/iphone_credentials.yml.example",
     "findmyiphone.gemspec",
     "lib/findmyiphone.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mattb/findmyiphone}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{MobileMe utilities}
  s.test_files = [
    "examples/iphone_2_fireeagle.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mechanize>, [">= 0.9.3"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.3"])
    else
      s.add_dependency(%q<mechanize>, [">= 0.9.3"])
      s.add_dependency(%q<json>, [">= 1.1.3"])
    end
  else
    s.add_dependency(%q<mechanize>, [">= 0.9.3"])
    s.add_dependency(%q<json>, [">= 1.1.3"])
  end
end
