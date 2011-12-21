GeoCMS.Views.LightboxMapEditor = Backbone.View.extend({

  render: function() {

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

    this.showFeatureOnMap(this.longitude, this.latitude, layer, carto);

    $(this.el).find(".actions button").click(function() {
      alert("helo");
    });
  },

  showFeatureOnMap: function(longitude, latitude, layer, carto) {
    var feature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(longitude, latitude));
    feature.attributes["thumbnail"] = "/assets/icons/1.gif";
    layer.addFeatures([feature]);
    original_geometry = layer.getDataExtent().getCenterLonLat();
    carto.map.setCenter(original_geometry, 6);
    //carto.displayLandmarkFeatures(self.id, landmark_layer);
  }

});

