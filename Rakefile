require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

def read(fname)
  File.exist?(fname) ? File.read(fname) : ""
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |g|
    g.name = "padrino-responders"
    g.version = read('VERSION')
    g.summary = "Simplified responders for Padrino framework"
    g.description = <<-DESCR
      This component is used to create slim controllers without unnecessery 
      and repetitive code.
    DESCR
    g.email = "kriss.kowalik@gmail.com"
    g.homepage = "http://github.com/nu7hatch/padrino-responders"
    g.authors = ["Kris 'nu7hatch' Kowalik"]
    g.add_dependency "padrino", ">= 0.9.14"
    g.add_development_dependency "riot", ">= 0.11.3"
    g.add_development_dependency "riot-rack", ">= 0"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = read('VERSION')
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "_metro #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
