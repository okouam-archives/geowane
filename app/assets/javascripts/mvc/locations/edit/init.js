//= require_tree .

$(function() {
  var location_id = $(".editor-content").data("id");
  $("#category_picker").edit_category({location_id: location_id});
  $(".information.portlet").edit_information({location_id: location_id});
  $(".feature.portlet").edit_feature({location_id: location_id});
  $(".comments.portlet").edit_comments({location_id: location_id});
  $(".map.portlet").manage_map({location_id: location_id});
  $('#logo_image').customFileInput();
  $('#photo_image').customFileInput();
});