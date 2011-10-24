$(function () {

  // CSS tweaks
  $('#header #nav li:last').addClass('nobg');
  $('.block_head ul').each(function() { $('li:first', this).addClass('nobg'); });
  $('.block table tbody tr:odd').css('background-color', '#fbfbfb');

  $('a[rel*=facebox]').facebox();
  $(".close-facebox").live('click', function() {
    $(document).trigger('close.facebox');
    return false;
  });

  $(document).bind('loading.facebox', function() {
    $(document).unbind('keydown.facebox');
    $('#facebox_overlay').unbind('click');
  });

  $(".close-facebox").click(function() {
    $(document).trigger("close.facebox");
    return false;
  });

});