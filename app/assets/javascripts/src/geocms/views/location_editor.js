GeoCMS.Views.LocationEditor = Backbone.View.extend({

  render: function() {
    var self = this;

      var carto = new Carto("faceboxmap");
      carto.addCommonControls();
      var layer = carto.createLayer("Features");
      var landmark_layer = carto.createLayer("Landmarks");
      new GeoCMS.Maps.Signposting(landmark_layer);
      var drag = new OpenLayers.Control.DragFeature(layer, {
        onStart: function() {notifyCoordinateChange(); }
      });
      var controls = [drag];
      carto.map.addControls(controls);
      $.each(controls, function (index, item) {
        item.activate();
      });
      var updateMap = function(data) {
        var locations = new OpenLayers.Format.GeoJSON().read(data);
        locations[0].attributes["thumbnail"] = "/assets/icons/1.gif";
        layer.addFeatures(locations);
        original_geometry = layer.getDataExtent().getCenterLonLat();
        carto.map.setCenter(original_geometry, 6);
        carto.displayLandmarkFeatures(self.id, landmark_layer);
      };
      $.getJSON("/locations/" + self.id, updateMap);
      $(".actions button").click(function() {
        alert("helo");
      });
  }

});

