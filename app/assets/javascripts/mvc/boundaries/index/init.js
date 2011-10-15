$(function() {
  $(".bulk-actions input").click(function() {
    var depth = $(this).siblings("select").val();
    if (depth > -1)
      window.location = "/boundaries?depth=" + $(this).siblings("select").val();
  });
});