function classify(classify_books,len){
  class_len=0;
  for(var k in classify_books){
    class_len++;
    html='<h3>'+k+':(共<font color="red">'+classify_books[k]["num"]+'</font>本)</h3><ul class="toggle">';
    for(var i in classify_books[k]["books"]){
      html+='<li>'+classify_books[k]["books"][i]+'</li>';
    }
    html+='</ul>';
    $("#classify").append(html);
  }
  html="你总共借了"+len+"本书,共分为"+class_len+"大类,详细如下:";
  $("#classify_alert").html(html);
}
