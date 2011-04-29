(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.BaseLayer = Class.extend({

    init: function(map, settings) {
      var layer_options = {
        resolutions: settings.resolutions, isBaseLayer: true, buffer: 0
      };
      var render_options = {
        map_imagetype: settings.imageType,
        format: settings.format,
        buffer: 0,
        layers: settings.layers
      };
      map.addLayer(new OpenLayers.Layer.WMS("base", settings.urls, render_options, layer_options));
    }
  });

})(window);
