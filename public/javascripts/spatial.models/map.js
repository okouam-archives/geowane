(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.Map = Class.extend({

    init: function(settings) {
      this.opts = settings;
      this.instance = new OpenLayers.Map(this.opts.element, this.opts.mapOptions);
      this.base_layer = new Spatial.Models.BaseLayer(this.instance, settings);
    }

  });

})(window);


