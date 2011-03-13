Spatial = Spatial || {};
Spatial.Models = Spatial.Models || {};

Spatial.Models.Feature = Class.extend({

  init: function(poi) {
    this.poi = poi;
  },

  createOpenLayersFeature: function() {
    var longitude = this.poi.attributes.longitude;
    var latitude = this.poi.attributes.latitude;
    var graphic = "/images/" + this.poi.attributes.icon;
    var geometry = new OpenLayers.Geometry.Point(longitude, latitude);
    var pointRadius = 12;
    if (location.size) pointRadius = location.size;
    var style = { externalGraphic: graphic, pointRadius: pointRadius, graphicYOffset: -pointRadius};
    return new OpenLayers.Feature.Vector(geometry, this, style);
  },

  showPopup: function(vector) {
    var coordinates = vector.geometry.getBounds().getCenterLonLat();
    var contents = "<b>" + this.poi.attributes.label + "</b>";
    vector.popup = new OpenLayers.Popup(null, coordinates, null, contents);
    vector.popup.autoSize = true;
    vector.layer.map.addPopup(vector.popup);
  },

  hidePopup: function(vector) {
    if (vector.popup) {
      vector.layer.map.removePopup(vector.popup);
      vector.popup.destroy();
      delete vector.popup;
    }
  }
});

