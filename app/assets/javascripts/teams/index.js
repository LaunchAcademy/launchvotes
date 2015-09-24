$(function(){
  $('tr').on('click', function() {
    $(this).find('a')[0].click();
  });
});
