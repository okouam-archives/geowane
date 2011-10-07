//= require_tree .

$(function() {
  $(".block").submit_form();
  $("#mappanel").manage_map();
  $(".portlet.categorization").name_picker();
  $(".portlet.boundaries").boundary_picker();
  $("#s_cities_").chosen();
  $("#s_categories_").chosen();
  $("#s_statuses_").chosen();
  $("#s_added_by_").chosen();
  $("#s_invalidated_by_").chosen();
  $("#s_corrected_by_").chosen();
  $("#s_modified_by_").chosen();
  $("#s_audited_by_").chosen();
  $("#s_field_checked_by_").chosen();
});