$.Class.extend('FeatureReader',
{
  init: function(el) {
    this.table = $(el);
  },

  getFeatures: function() {
    var features = [];
    this.table.find("tbody tr").each(function() {
      var row = $(this);
      var id = row.data("id");
      var longitude = row.data("longitude");
      var latitude = row.data("latitude");
      var name = row.data("name");
      var point = new OpenLayers.Geometry.Point(longitude, latitude);
      var feature = new OpenLayers.Feature.Vector(point, {name: name});
      feature.attributes["id"] = id;
      feature.attributes["longitude"] = longitude;
      feature.attributes["latitude"] = latitude;
      features.push(feature);
    });
    return features;
  }
});