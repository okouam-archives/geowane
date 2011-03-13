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
    console.debug(vector);
    var attributes = this.poi;
    if (!attributes.label) return;
    var coordinates = vector.layer.map.geometry.getBounds().getCenterLonLat();
    var resolution = map.instance.getResolution();
    var newCoordinates = new OpenLayers.LonLat(coordinates.lon + resolution * - 75, coordinates.lat + resolution * 70);
    var size = new OpenLayers.Size(200, 20);
    var contents = "<b>" + attributes.label + "</b>";
    if (attributes.category) {
      contents = contents + "<br/>" + attributes.category;
    }
    vector.popup = new OpenLayers.Popup(attributes.label, newCoordinates, size, contents);
    vector.popup.feature = vector;
    vector.layer.map.addPopup(vector.popup);
    vector.popup.updateSize();
  },

  hidePopup: function(vector) {
    console.debug(vector);
    if (vector.popup) {
      vector.popup.feature = null;
      vector.layer.map.removePopup(feature.popup);
      vector.popup.destroy();
      vector.popup = null;
    }
  }
});

