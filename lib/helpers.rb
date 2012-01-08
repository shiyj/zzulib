# encoding: utf-8

module Helpers
  
  require 'net/smtp'
#数据读取和分析	
  def get_html url
		cov = Iconv.new( "UTF-8//IGNORE","GB2312//IGNORE" )
    #表示已经开始查询
      settings.server_cache[session["v_cardno"]]={:start_time=>Time.now} if /SrchLog/ =~ url
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
    session["is_login"] && session["v_cardno"] && session["rdrecno"]
  end

	def get_lib_history
    #st=session["v_cardno"][1..2]
		time=Time.now
		endtime=time.to_s[0..9].gsub('-','')
		url="http://202.197.191.210/cgi-bin/SrchLog?v_cardno=#{session["v_cardno"]}&v_rdrecno=#{session["rdrecno"]}&v_starttime=20080901&v_endtime=#{endtime}&v_maxnum=2000"
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
				hash[2] = book.children[5].content[0..1]
				books << hash
			elsif book.children[2].content == '读者名称:'
					username=book.children[3].content
			end
		end
    #将读取到的信息以编号存储为文件.
    #如果是已经登录的则不存储,专门针对测试数据而言.
    #unless is_login?
    #  File.open(session["v_cardno"],'w') do |f|
    #    f << books
    #  end
    #end
		session["username"] = username
    len = books.length.to_s
    if is_login?
      User.first_or_create({:card_no=>session["v_cardno"]},
                         {:name=>username,:books_num=>len})
		  settings.server_cache[session["v_cardno"]][:data]=[books,username,len,get_classify_hash,get_rank(len)]
    else
      
		  [books,username,len,get_classify_hash,get_rank(len)]
    end
	end

######数据调用
	def get_test_data
		#直接读取html文件,省去login和get_lib_history
		text =File.read("books")
		get_my_data text
	end

  def get_my_books
    text = get_lib_history
    get_my_data text
  end
  
  def long_time_query
    if is_login?
      if(settings.server_cache[session["v_cardno"]])
        if(settings.server_cache[session["v_cardno"]][:data])
          settings.server_cache[session["v_cardno"]][:data]
        else
          sleep(10)
          settings.server_cache[session["v_cardno"]][:data]?settings.server_cache[session["v_cardno"]][:data] : "waiting"
        end
      else
        thread = Thread.new do
          get_my_books
        end
        sleep(20)
        "waiting"
      end
    else
      get_test_data
    end
  end



  def get_classify_hash
    books_index=[]
    BooksIndex.all().each do |ind|
      books_index << [ind.name,ind.zhongtu,ind.ketu]
    end
    books_index
  end
  def get_rank num
    rank_name=[]
    counts=User.count
    rank_num=User.count(:books_num.gt => num) + 1
    User.all(:order=>[:books_num.desc],:limit=>5).each do |user|
      rank_name << [user.name,user.books_num]
    end
    [rank_name,counts,rank_num]
  end
#########邮件
  def mail_to_me msg,email
    host_email=open('email.yaml'){ |e| YAML.load(e) }
    msg_to_me = [ "Subject: advice from <"+email+">\n", "\n", msg+"\nFrom:"+email ]
    msg_to_you = [ "Subject: Thanks for your advice\n", "\n", "您的建议已收到,这封邮件是对您的支持表示感想.\n\n我会在查阅邮件后专门给你回信.\n\n你也可以联系我: shiyj.cn@gmail.com\n\n史英建" ]
    Net::SMTP.start( host_email[:service], host_email[:port], host_email[:helo_dome],host_email[:email_address], host_email[:pwd], :login ) do |smtp|
      smtp.sendmail( msg_to_me,  host_email[:email_address], 'syj1syj1@163.com' )
      smtp.sendmail( msg_to_you,  host_email[:email_address], email )
    end
  end
end
