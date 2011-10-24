//= require_tree .

$(function($) {
  var featureReader = new FeatureReader($("table.main"));
  var locations = featureReader.getFeatures();
  $(".map.portlet").manage_map({locations: locations, footer: $(".map-footer")});
  $("table.list.updates").checkboxes();
  $("table.list.updates").add_category_inline($(".action-portlet.add_category select").html());
  $("table.list.updates").add_comment_inline($(".action-portlet.add_comment .portlet-content").html());
  $(".bulk-actions").bulk_actions();
});


