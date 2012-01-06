# encoding: utf-8
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'iconv'
require 'erb'
require 'date'
require 'data_mapper'
require './lib/db'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:db/data.db')
DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

#Dir["lib/*.rb"].each { |x| load x }
load './lib/helpers.rb'

before do
  heades "X-Frame-Options" => "SAMEORIGIN"
end

helpers do
	include Helpers
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
  if is_login?
    erb '<%= get_my_books %>',:layout=>false
  else
    erb '<%= get_test_data %>',:layout=>false
  end
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
  erb '<%= get_rank %>',:layout=>false
end
