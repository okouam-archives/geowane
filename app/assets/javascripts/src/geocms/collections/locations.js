GeoCMS.Collections.Locations = Backbone.Collection.extend({

  model: GeoCMS.Models.Location,

  url: function() {
    if (!this.criteria) return "/locations";
    var query = "?";
    $.each(this.criteria.attributes, function(name, val){
      if (name == "per_page" || name == "page" || name == "sort") query =  query = query + "&" + name + "=" + val;
      else query = query + "&s[" + name + "]=" + val;
    });
    var url = "/locations" + query;
    return url;
  },

  parse: function(results) {
    this.criteria.set({total_entries: results.total_entries}, {silent: true});
    return results.locations;
  },

  asFeatures: function() {
    return _.map(this.models, function(location) {
      var point = new OpenLayers.Geometry.Point(location.get("longitude"), location.attributes["latitude"]);
      var feature = new OpenLayers.Feature.Vector(point, {name: location.attributes["name"]});
      feature.attributes["id"] = location.id;
      feature.attributes["longitude"] = location.get("longitude");
      feature.attributes["latitude"] = location.get("latitude");
      return feature;
    });
  }
});