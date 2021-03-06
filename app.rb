# encoding: utf-8
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'iconv'
require 'erb'
require 'time'
require 'data_mapper'
require './lib/db'

if ENV['VCAP_SERVICES'] #Cloud foundry
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
DataMapper.auto_upgrade!

enable :sessions

#Dir["lib/*.rb"].each { |x| load x }
load './lib/helpers.rb'

before do
  headers "X-Frame-Options" => "SAMEORIGIN"
  clear_cache_thread = Thread.new do
    while true do
      settings.server_cache.each do |k,v|
        if (v[:start_time] - Time.now >= 3600)
          settings.server_cache.delete(k)
        end
      end
      sleep(300)
    end
  end
end

helpers do
  include Helpers
end
configure do
  set :server_cache,{}
end
get '/test' do
  v_cardno = '张三'
  rdrecno = '000'
  session.clear
  erb :chart,:locals=>{ :v_cardno=>v_cardno,:rdrecno=>rdrecno }
end
get '/mylib' do
  v_cardno = session["v_cardno"]
  rdrecno = session["rdrecno"]
  erb :chart,:locals=>{ :v_cardno=>v_cardno,:rdrecno=>rdrecno }
end

get '/getmybooks' do
  erb '<%= long_time_query %>',:layout=>false
end

get '/' do
  erb :index,:layout=>false
end

get '/login' do
  username = params[:username]
  password = params[:password]
  if(username=='admin'&&password=='admin')
    session["is_login"]=false
    "login_success"
  else
    login username,password
    if(session["is_login"])
      "login_success"
    else
      "login_faile"
    end
  end
end
get '/loginout' do
  session.clear
end

post '/feedback' do
  msg = params[:msg]
  email = params[:email]
  succ = true
  tries = 0
  begin
    tries +=1
    mail_to_me msg,email
  rescue
    #retry unless tries >=3
    succ = false
  end
  succ ? "send_success":"send_faile"
end
get '/kezh' do
  erb '<%= get_classify_hash %>',:layout=>false
end
get '/tt' do
  erb '<%= "BINGO! From " + request.ip  %>',:layout=>false
end
