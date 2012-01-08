function rank(){
  html="总共有<font color='red'>"+Rank_data[1]+"</font>人测试,你排<font color='red'>第"+Rank_data[2]+"名</font>.";
  html+="其中的前五名如下:";
  $("#rank_alert").html(html);
  for(var i in Rank_data[0]){
    html='<tr><td>'+Rank_data[0][i][0]+'</td><td>';
    html+=Rank_data[0][i][1]+'</td></tr>';
    $("#rank_container").append(html);
  }
}
