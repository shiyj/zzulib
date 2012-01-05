function chart(hash_books,username){
  var line1=hash_books;
  var plot1 = $.jqplot('mybooktrend', [line1], {
			animate: true,
			animateReplot: true,
      title:'<h4>'+username+'</h4>',
      axes:{
        xaxis:{
          renderer:$.jqplot.DateAxisRenderer,
          tickOptions:{
            formatString:'%y.%m.%#d.'
          } 
        },
        yaxis:{
          tickOptions:{
            formatString:'%0.0f'
            }
        },
      },
      highlighter: {
        show: true,
        sizeAdjust: 7.5,
				formatString:'<span style="color:red;">你在%s借了%s本书:</span>'
      },
      cursor: {
				show: true,
				zoom: true,
      }
  });

$('#mybooktrend').bind('jqplotDataMouseOver', 
    function (ev, seriesIndex, pointIndex, data) {
      var chart_left = $('#mybooktrend').offset().left,
        chart_top = $('#mybooktrend').offset().top,
        x = plot1.axes.xaxis.u2p(data[0]),  // convert x axis unita to pixels
        y = plot1.axes.yaxis.u2p(data[1]);  // convert y axis units to pixels
			var html = '<span style="color:blue;">';
			for(var i=0;i<data[1];i++){
				html +=line1[pointIndex][2][i];
				html +='</br>';
			}
			html += '</span>';
      $('#tooltip1b').css({left:chart_left+x-160, top:chart_top+y+10});
      $('#tooltip1b').html(html);
      $('#tooltip1b').show();
		});
	$('#mybooktrend').bind('jqplotDataUnhighlight', 
      function (ev, seriesIndex, pointIndex, data) {
          $('#tooltip1b').empty();
          $('#tooltip1b').hide();
   		});
};
