$(function() {
  var features = new FeatureReader("table.main").getFeatures();
  $(".map.portlet").manage_map(features);
  $("table.main").checkboxes();
  $(".bulk-actions").bulk_actions();
  $("th a").click(function() {
    var url = jQuery.param.querystring(window.location.href, {sort: $(this).data("sort"), page: 1});
    window.location = url;
  });
});