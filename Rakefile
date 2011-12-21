require "rake"  
require "rake/testtask"  

task :default => :local

desc "Publish the blog locally."
task :local do
    puts "http://localhost:3002"
    `thin start -R config.ru -p 3002`
end

Rake::TestTask.new do |test|
	test.libs << "tests"
	test.test_files = Dir["tests/*_test.rb"]
	test.verbose = true
end

