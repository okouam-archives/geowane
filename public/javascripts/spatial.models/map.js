(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.Map = Class.extend({

    init: function(settings) {
      this.opts = settings;
      this.instance = new OpenLayers.Map(this.opts.element, this.opts.mapOptions);
      this.view = new Spatial.Models.View(this.instance);
      this.base_layer = new Spatial.Models.BaseLayer(this.instance, settings);
      this.setupControls();
      this.view.showFullExtent();
    },

    zoomToFeatures: function(layer_id) {
      var bounds = this.instance.getLayer(layer_id).getDataExtent();
      if (bounds) this.instance.zoomToExtent(bounds);
    },

    removeLayer: function(layer_id) {
      var layer = this.instance.getLayer(layer_id);
      if (layer) this.instance.removeLayer(layer);
    },

    setupControls: function() {
      this.instance.removeControl(this.instance.getControlsByClass("OpenLayers.Control.PanZoom")[0]);
      //this.instance.addControl(new OpenLayers.Control.ScaleLine());
      //this.instance.addControl(new OpenLayers.Control.PanZoomBar());
    }

  });

})(window);


