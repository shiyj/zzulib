require "rake"  
require "rake/testtask"  
require 'data_mapper'
require "./lib/db"
require "yaml"
task :default => :local

desc "Publish the blog locally."
task :local do
  puts "http://localhost:3002"
    `thin start -R config.ru -p 3002`
end

desc "config email"
task :set_email do
  email={}
  email[:email_address]=ask('Your email address,such as zzulib@163.com:')
  email[:port]=ask('Port:')
  email[:helo_dome]=ask('Helo_dome:')
  email[:service]=ask('Service,eg:smtp.163.com:')
  email[:pwd]=ask('Your email passward:')
  email[:authtype]=ask('Authtype,eg: ":login":')
  open('email.yaml','w') {|e| YAML.dump(email,e)}
end


desc "database migration"
task :db_migrate do
  if ENV['VCAP_SERVICES']
    require 'json'
    svcs = JSON.parse ENV['VCAP_SERVICES']
    mysql = svcs.detect { |k,v| k =~ /^mysql/ }.last.first
    creds = mysql['credentials']
    user, pass, host, name = %w(user password host name).map { |key| creds[key] }
    DataMapper.setup(:default, "mysql://#{user}:#{pass}@#{host}/#{name}")
  else
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:db/data.db')
  end
  DataMapper.finalize
  DataMapper.auto_migrate!
  init_db
  puts 'migration finished!'
end

def init_db 
  i = 0
  a = []
  open('classify').each do |line|
    i +=1
    a[i-1]=line.chomp
    if i==3
      i=0
      BooksIndex.create(:name=>a[0],:ketu=>a[1],:zhongtu=>a[2])
    end
  end
end

Rake::TestTask.new do |test|
  test.libs << "tests"
  test.test_files = Dir["tests/*_test.rb"]
  test.verbose = true
end

def ask message
  print message
  STDIN.gets.chomp
end
