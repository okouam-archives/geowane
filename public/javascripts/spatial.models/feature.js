Spatial = Spatial || {};
Spatial.Models = Spatial.Models || {};

Spatial.Models.Feature = Class.extend({

  init: function(longitude, latitude, graphic) {
    var geometry = null;
    geometry = new OpenLayers.Geometry.Point(location.longitude, location.latitude);
    var pointRadius = 12;
    if (location.size) pointRadius = location.size;
    var rendering = { externalGraphic: graphic, pointRadius: pointRadius, graphicYOffset: -pointRadius};
    return new OpenLayers.Feature.Vector(geometry, location, rendering);
  }

});

