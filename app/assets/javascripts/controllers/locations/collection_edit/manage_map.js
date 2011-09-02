$.Controller("ManageMap",
{
  init: function(el, options) {
    this.map = Carto.build();
    Carto.addCommonControls(this.map);
    this.layer = Carto.createLayer("Features", this.map);
    this.setupControls();
    this.loadFeatures(options.locations);
  },

  "a:contains('Save') click": function() {
    this.publish("geocms.locations-updating");
    var features = this.layer.features;
    var data = {locations: [], commit: "true"};
    for(var i = 0; i < features.length; i++) {
      var feature = features[i];
      var geometry = feature.geometry;
      data.locations[i] = {longitude:geometry.x, latitude: geometry.y, id: feature.attributes["id"]};
    }
    $.ajax({
      url: "/locations",
      data: data,
      success: this.hideActions(),
      context: this,
      type: "PUT",
      dataType: "json"
    });
    return false;
  },

  "a:contains('Cancel') click": function() {
    var features = this.layer.features;
    for(var i = 0; i < features.length; i++) {
      var longitude = features[i].attributes.longitude;
      var latitude = features[i].attributes.latitude;
      features[i].move(new OpenLayers.LonLat(longitude, latitude));
    }
    this.hideActions();
  },

  showActions: function() {
    this.element.find(".portlet-header span").show();
  },

  hideActions: function() {
    this.element.find(".portlet-header span").hide();
  },

  loadFeatures: function(locations) {
    var layer = this.layer;
    $.getJSON("/locations/" + locations,
      function(data) {
        Carto.displayNumberedFeaturesById(data, layer);
      }
    );
  },

  setupControls: function() {
    var self = this;
    var drag = new OpenLayers.Control.DragFeature(this.layer, {
      onStart: function() {
        Carto.hideTipsy();
      },
      onComplete: function() {
        self.showActions();
      }
    });
    var tooltip = new OpenLayers.Control.SelectFeature(this.layer, {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function(feature) {
        Carto.showLabel(feature);
        $("body").css({cursor: "pointer"});
      },
      outFeature: function() {
        $("body").css({cursor: "default"});
        Carto.hideTipsy();
      }
    });

    var controls = [tooltip, drag];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  }
});