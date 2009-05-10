# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dots}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Celis"]
  s.date = %q{2009-05-10}
  s.description = %q{Free progress dots for your scripts.}
  s.email = ["stephen@stephencelis.com"]
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["History.rdoc", "Manifest.txt", "Rakefile", "README.rdoc", "cucumber.yml", "dots.gemspec", "features", "features/dots.feature", "features/step_definitions/dots_steps.rb", "features/support/env.rb", "lib", "lib/dots/kaoemoji.rb", "lib/dots/rainbows.rb", "lib/dots/redgreen.rb", "lib/dots.rb", "spec/dots_spec.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dots}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Free progress dots for your scripts}
  s.homepage = "http://github.com/stephencelis/dots"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end
