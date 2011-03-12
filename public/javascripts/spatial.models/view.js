Spatial = Spatial || {};
Spatial.Models = Spatial.Models || {};

Spatial.Models.View = Class.extend({

  init: function(map) {
    this.map = map;
  },

  showFullExtent: function() {
    this.map.setCenter(new OpenLayers.LonLat(-4.02054977, 5.32823992), 0, false, false);
    this.map.zoomToMaxExtent();
  }

});