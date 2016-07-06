require "rake/testtask"
require "rake"

task :build do
    puts `gem build remind.gemspec`
end

task :install do
    puts `gem install remind-1.0.0.gem`
end

Rake::TestTask.new(:test) do |t|
    t.libs << 'test'
    t.libs << 'lib'
end

desc "Build and Install"
task :default => [:build, :install]
