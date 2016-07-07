require "rake/testtask"
require "rake"

task :build do
    puts `gem build remind.gemspec`
end

task :install do
    puts `gem install remind-1.0.0.gem`
end

task :package do
    Rake::Task[:build].invoke and Rake::Task[:install].invoke
end

Rake::TestTask.new(:test) do |t|
end

task :default => [:package]
