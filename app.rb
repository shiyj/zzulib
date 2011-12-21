# encoding: utf-8
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'iconv'
require 'erb'
require 'date'
#require './extend'

enable :sessions

Dir["lib/*.rb"].each { |x| load x }

HASH_INDEX = {"A"=>"马克思主义、列宁主义、毛泽东思想", "B"=>"哲学", "C"=>"社会科学总论", "D"=>"政治、法律", "E"=>"军事", "F"=>"经济", "G"=>"文化、科学、教育、体育", "H"=>"语言、文字", "I"=>"文学", "J"=>"艺术", "K"=>"历史、地理", "N"=>"自然科学总论", "O"=>"数理科学和化学", "P"=>"天文学、地理科学", "Q"=>"生物科学", "R"=>"医学、卫生", "S"=>"农业科学", "T"=>"工业技术", "U"=>"交通运输", "V"=>"航空、航天", "X"=>"环境科学、劳动保护科学（安全科学）", "Z"=>"综合性图书"}


helpers do
	include Helpers
end

get '/test' do
	books,username = get_test_data
	hash_books = change_to_jsdata books
	erb :chart,:locals=>{ :num=>books.length.to_s,:username=>username, :hash_books=>hash_books }
end
get '/' do
	erb :index,:layout=>false
end

get '/chart' do
  if is_login?
  	books = session["books"]
	  username = session["username"]
  else
    books,username = get_test_data
  end
	hash_books = change_to_jsdata books
	erb :chart,:locals=>{ :num=>books.length.to_s,:username=>username, :hash_books=>hash_books }
end

get '/login' do
  username = params[:username]
	password = params[:password]
	login username,password
	if(session["is_login"])
		"login_success"
	else
		"login_faile"
	end
end
get '/loginout' do
	session.clear
end
get '/main' do
	text = get_lib_history
  books,username = get_my_data text
  erb :chart,:locals=>{ :num=>books.length.to_s,:username=>username }
end
get '/tt' do
	books,username = get_test_data
	erb :test,:locals=>{ :num=>books.length.to_s,:username=>username }
end

get '/gettest' do
	text = query_html 'engin','19880115111'
	books,username = get_my_data text
	hash_books = change_to_jsdata books
	erb :chart, :locals=> { :num=>books.length.to_s,:username=>username, :hash_books=>hash_books }
end
get '/liu' do
	text = query_html 'liusir14','liushuai1014'
	books,username = get_my_data text
	hash_books = change_to_jsdata books
	erb :chart, :locals=> { :num=>books.length.to_s,:username=>username, :hash_books=>hash_books }
end
