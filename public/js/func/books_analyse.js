function change_to_chart_data(books){
  var hash = {};
  var len = books.length;
  for(var i = 0;i<len;i++){
    var datetime = books[i][0];
    if(!hash[datetime]){
      hash[datetime]={"num":0,"books":[]}
    }
    hash[datetime]["num"] +=1;
    hash[datetime]["books"].push(books[i][1]);
  }
  arr = [];
  for(var k in hash){
    k_c=k.replace(/\./g,"-");
    var sub_arr=[k_c,hash[k]["num"],hash[k]["books"]];
    arr.push(sub_arr);
  }
  return arr;
};
function change_to_cassify_data(books,books_index){
  classify_hash = {};
  var len=books_index.length;
  zhongtu = {};
  ketu = {};
  for(var i=0;i<len;i++){
    zhongtu[books_index[i][1]]=books_index[i][0];
    ketu[books_index[i][2]]=books_index[i][0];
  }
  hash=change_to_books_index(books);
  for(var k in hash){
    var name=""
    if(k[0]>="0"&&k[0]<="9"){
      name=ketu[k] ? ketu[k] : ketu_f(k,ketu);
    }
    else{ 
      name =zhongtu[k[0]] ? zhongtu[k[0]] : zhongtu_f(k,zhongtu);
    };
    if(!classify_hash[name]){classify_hash[name]={"num":0,"books":[]};}
    classify_hash[name]["num"]+=hash[k]["num"];
     classify_hash[name]["books"]=classify_hash[name]["books"].concat(hash[k]["books"]);
  }
  return classify_hash;
}
function change_to_books_index(books){
  var hash = {};
  var len = books.length;
  for(var i = 0;i<len;i++){
    var index=books[i][2];
    if(!hash[index]){
      hash[index]={"num":0,"books":[]};
    }
    hash[index]["num"]+=1;
    hash[index]["books"].push(books[i][1]);
  }
  return hash;
}
function ketu_f(str,ketu){
  if(str[0]=="0"){return ketu["00-09"] }
  else if(str[0]=="1"){return ketu["10-19"]}
  else if(str>="21"&&str<="26"){return ketu["21-26"]}
  else if(str>="27"&&str<="29"){return ketu["27-29"]}
  else if(str>="30"&&str<="33"){return ketu["30-33"]}
  else if(str>="34"&&str<="35"){return ketu["34-35"]}
  else if(str>="37"&&str<="39"){return ketu["37-39"]}
  else if(str>="40"&&str<="41"){return kety["40-41"]}
  else if(str>="42"&&str<="47"){return ketu["42-47"]}
  else if(str>="52"&&str<="53"){return ketu["52-53"]}
  else if(str>="55"&&str<="57"){return ketu["55-57"]}
  else if(str>="58"&&str<="59"){return ketu["58-59"]}
  else if(str>="60"&&str<="64"){return ketu["60-64"]}
  else if(str>="65"&&str<="69"){return ketu["65-69"]}
  else if(str>="71"&&str<="89"){return ketu["71-89"]}
  else if(str[0]=="9"){return ketu["90-99"]}
  else{return "无法读取分类"}
}
function zhongtu_f(str,zhongtu){
  if(str=="TM" || str=="TN" || str=="TP"){return zhongtu["TM、TN、TP"];}
  else if(str[0]=="O"){
    if(str=="O1"||str=="O2"){return zhongtu["O1-O2"];}
    else if(str>="O3"&&str<="O5"){return zhongtu["O3-O5"];}
    else{return zhongtu["O6-O9"];}
  }
  else if(str=="D9"){return zhongtu["D9"];} 
  else if(str=="B9"){return zhongtu["B9"];}
  else if(str[0]=="T" || str[0]=="U" ||str[0]=="V" ||str[0]=="X"){
    return zhongtu["T、U、V、X"];
  }
  else{return "无法读取分类"}
}
