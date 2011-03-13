(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.InteractiveLayer = Class.extend({

    init: function(map, id, options) {
      this.layer = new OpenLayers.Layer.Vector(id, {"reportError": true });
      var controls = [];

      if (options.showPopups){
        var selectControl = new OpenLayers.Control.SelectFeature(this.layer, { multiple: false, hover: true });
        controls.push(selectControl);
      }

      var dragControl = new OpenLayers.Control.DragFeature(this.layer);
      dragControl.onStart = function() {
        document.body.style.cursor = 'pointer';
      };
      dragControl.documentDrag = true;
      dragControl.onComplete = options.persistor ? options.persistor : function() {
        document.body.style.cursor = 'auto';
      };
      controls.push(dragControl);

      _.each(controls, function(control) {
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
    }

  });

})(window);
