# encoding: utf-8
module Helpers
	b=["aa","bb"]
	def get_html url
		cov = Iconv.new( "UTF-8//IGNORE","GB2312//IGNORE" )
		text=open(url).read
		cov.iconv(text)
	end

	def login name, pwd
		url = "http://202.197.191.210/cgi-bin/confirmuser?v_newuser=0&v_regname=#{name}&v_cardno=&v_passwd=#{pwd}"
		html= get_html url
		reg = /name=v_regname value=(.+)>.+name=w_rdrecno value=(.+)>.+name=v_cardno value=(.+)>.+name=v_rdrecno value=(.+?)>/m
		arr = reg.match(html)
		if($3 && $4)
			session["is_login"] = true
			session["v_cardno"] = $3
			session["rdrecno"] = $4
		else
			session["is_login"]=false
		end
	end

  def is_login?
    session["is_login"]
  end

	def get_lib_history
		time=DateTime.now
		endtime=time.year.to_s+time.month.to_s+time.day.to_s
		url="http://202.197.191.210/cgi-bin/SrchLog?v_cardno=#{session["v_cardno"]}&v_rdrecno=#{session["rdrecno"]}&v_starttime=20070901&v_endtime=#{endtime}&v_maxnum=2000"
		get_html url
	end

	def get_my_data text
		doc = Nokogiri::HTML(text)
		books = []
		username = ""
		doc.css('table > tr').each do |book|
			if book.children[2].content == '流通借出'
				#hash中的0,1,3分别表示借书时间(datetime),书名(bookname),书分类号(index)
				#为了节省空间采用数组而不是hash.
				hash=[]
				hash[0] = book.children[0].content
				hash[1] = book.children[4].content
				hash[2] = book.children[5].content[0..2]
				books << hash
			elsif book.children[2].content == '读者名称:'
					username=book.children[3].content
			end
		end
		#session["books"] = books
    #将读取到的信息以编号存储为文件.
    #如果是已经登录的则不存储,专门针对测试数据而言.
    #unless is_login?
    #  File.open(session["v_cardno"],'w') do |f|
    #    f << books
    #  end
    #end
		session["username"] = username
		[books,username]
	end

	def change_to_jsdata books
		hash = {}
		books.each do |book|
			datetime=book[0]
			if !hash[datetime]
				hash[datetime]={:num=>0,:books=>[]}
			end
			hash[datetime][:num] +=1
			hash[datetime][:books] << book[1]
		end
		arr=[]
		hash.each do |k,v|
			sub_arr=[k,v[:num],v[:books]]
			arr << sub_arr
		end
		arr
	end
######以下为测试数据示例
	def get_test_data
		#直接读取html文件,省去login和get_lib_history
		text =File.read("books")
		get_my_data text
	end

	def query_html name,pwd
		url = "http://202.197.191.210/cgi-bin/confirmuser?v_newuser=0&v_regname=#{name}&v_cardno=&v_passwd=#{pwd}"
		html= get_html url
		reg = /name=v_regname value=(.+)>.+name=w_rdrecno value=(.+)>.+name=v_cardno value=(.+)>.+name=v_rdrecno value=(.+?)>/m
		arr = reg.match(html)
		puts $1,$2,$3,$4
		time=DateTime.now
		endtime=time.year.to_s+time.month.to_s+time.day.to_s
		url2="http://202.197.191.210/cgi-bin/SrchLog?v_cardno=#{$3}&v_rdrecno=#{$4}&v_starttime=20070901&v_endtime=#{endtime}&v_maxnum=2000"
		get_html url2
	end

end
