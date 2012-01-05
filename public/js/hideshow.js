function toggle_ul() {

var showText='显示';
var hideText='隐藏';

var is_visible = false;

$('.toggle').prev().append(' <a href="#" class="toggleLink">'+hideText+'</a>');

$('.toggle').show();

$('a.toggleLink').click(function() {

is_visible = !is_visible;

if ($(this).text()==showText) {
$(this).text(hideText);
$(this).parent().next('.toggle').slideDown('normal');
}
else {
$(this).text(showText);
$(this).parent().next('.toggle').slideUp('normal');
}
return false;
});
}
