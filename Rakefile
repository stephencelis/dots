defaults = [:requirements]
required = []
required << "* Ruby 1.8.7 or greater is required" if RUBY_VERSION < "1.8.7"

desc "Show any uninstalled requirements to run the full test suite"
task :requirements do
  puts required
end

begin
  require "spec/rake/spectask"

  desc "Run all specs"
  Spec::Rake::SpecTask.new :spec do |t|
    t.ruby_opts = ["-Ilib"]
    t.spec_opts = ["--color"]
    t.spec_files = FileList["spec/**/*_spec.rb"]
  end

  defaults << :spec
rescue LoadError
  required << "* RSpec is required."
end

begin
  require "cucumber"
  require "cucumber/rake/task"

  desc "Run all features"
  Cucumber::Rake::Task.new :features do |t|
    t.cucumber_opts = "features --no-source --format=progress"
    t.fork = false
  end

  defaults << :features
rescue LoadError
  required << "* Cucumber is required"
end

defaults << :requirements if defaults.empty?

task :default => defaults
