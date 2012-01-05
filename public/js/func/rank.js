function rank(){
  html="总共有"+Rank_data[1]+"人测试,你排第"+Rank_data[2]+"名";
  html+="其中的前五名如下:";
  $("#rank_alert").html(html);
  for(var i in Rank_data[0]){
    html='<tr><td>'+Rank_data[0][i][0]+'</td><td>';
    html+=Rank_data[0][i][1]+'</td></tr>';
    $("#rank_container").append(html);
  }
}
