$(document).ready(function(){
  $('#menulink li').click(function(){
    if (!$(this).hasClass('selected')) {
      $('#menulink li').removeClass('selected');
	    $(this).addClass('selected');
	    $('#main div.parent').slideUp('1500');
      var i=$('#menulink > li').index(this);
      var len=$('#menulink > li').length;
      if(i!=(len - 1)){
	      $('#main div.parent:eq(' + i + ')').slideDown('1500');
        $('#nav').html(this.textContent)
      } else {
        $.ajax({
          type:'GET',
          url:'/loginout',
          success:function(){
            alert('退出成功');
            window.location.href="/"; 
          }
        })
      }
	 }
  })
})
