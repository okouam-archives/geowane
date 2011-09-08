//= require_tree .

$(function() {
  $(".block").submit_form();
  $("#mappanel").manage_map();
  $(".portlet.categorization").name_picker();
  $(".portlet.boundaries").boundary_picker();
});