(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.InteractiveLayer = Class.extend({

    init: function(map, id) {
      this.layer = new OpenLayers.Layer.Vector(id, {"reportError": true });

      var selectControl = new OpenLayers.Control.SelectFeature(this.layer, { multiple: false, hover: true });

      var dragControl = new OpenLayers.Control.DragFeature(this.layer);
      dragControl.onStart = function() {document.body.style.cursor = 'pointer';};
      dragControl.onComplete = this.onDragFeatureComplete.bind(this);
      dragControl.documentDrag = true;

      _.each([dragControl, selectControl], function(control) {
        map.instance.addControl(control);
        control.activate();
      });

      map.instance.addLayer(this.layer);

      this.layer.events.on({
        'featureselected': function(evt) {
          evt.feature.attributes.showPopup(evt.feature, map);
        },
        'featureunselected': function(evt) {
          evt.feature.attributes.hidePopup(evt.feature, map);
        }
      });
    },

    load: function(locations, icon_path) {
      var features = _.map(locations, function(location) {
        var feature = new Spatial.Models.Feature(location);
        return feature.createOpenLayersFeature();
      });
      this.layer.addFeatures(features, {silent: false});
    },

    onDragFeatureComplete: function(feature, pixel) {
      document.body.style.cursor = 'auto';
      if (this.opts.observer.onDragComplete) this.opts.observer.onDragComplete(feature, this.instance.getLonLatFromPixel(pixel));
    }

  });

})(window);
