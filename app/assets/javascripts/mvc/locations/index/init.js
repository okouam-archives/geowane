//= require_tree .

$(function() {
  var features = new FeatureReader("table.main").getFeatures();

  $(".map.portlet").manage_map({features: features, footer: $(".map-footer")});

  new GeoCMS.Helpers.DataTable({el: "table.main"});

  new GeoCMS.Helpers.SortableTable({el: "table.main"});

  $(".bulk-actions").bulk_actions(jQuery.param.querystring());

  new GeoCMS.Views.LocationSearch({el: "#search-bar"});

  new GeoCMS.Views.LocationSearchResults({el: "table.main tbody"});
});