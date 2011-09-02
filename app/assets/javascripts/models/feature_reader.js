$.Class.extend('FeatureReader',
{
  init: function(el) {
    this.table = $(el);
  },

  getFeatures: function() {
    var features = [];
    this.table.find("tbody tr").each(function() {
      var row = $(this);
      var longitude = row.data("longitude");
      var latitude = row.data("latitude");
      var name = row.data("name");
      var point = new OpenLayers.Geometry.Point(longitude, latitude);
      var feature = new OpenLayers.Feature.Vector(point, {name: name});
      features.push(feature);
    });
    return features;
  }
});