$.Controller("LocationsCollectionEditMap",
{
  init: function(el, options) {
    OpenLayers.ImgPath = "/images/OpenLayers/";
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
    this.map = new OpenLayers.Map("mappanel", {
        theme: null,
        maxResolution: 0.02197265625,
        numZoomLevels: 14,
        restrictedExtent: new OpenLayers.Bounds(-18.598705491875, -0.72081361875, 5.065845289375, 26.4046746625),
        maxExtent: new OpenLayers.Bounds(-62.6428949, -11.4905018, 49.85710501, 35.844773),
        controls: []
    });
    var urls = [
      "http://a.maps.geocms.co/tilecache.py?",
      "http://b.maps.geocms.co/tilecache.py?",
      "http://c.maps.geocms.co/tilecache.py?"
    ];
    this.map.addLayer(new OpenLayers.Layer.WMS("base", urls, {layers: "data01", format: "image/png"}));
    this.setupFeatureLayer();
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
      success: function(data) {
        this.hideActions();
        var locations = this.parseGeoJSON(data);
        this.publish("geocms.locations-updated", locations);
      },
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
    var self = this;
    $.getJSON("/locations/" + locations,
      function(data) {
        var locations = self.parseGeoJSON(data);
        self.layer.addFeatures(locations);
        self.map.zoomToExtent(self.layer.getDataExtent());
        self.publish("geocms.locations-retrieved", locations);
      }
    );
  },

  parseGeoJSON: function(data) {
    var geojson_format = new OpenLayers.Format.GeoJSON();
    var locations = geojson_format.read(data);
    for(var i = 0; i < locations.length; i++) {
      locations[i].attributes["counter"] = (i+1);
      locations[i].attributes["thumbnail"] = "/icon/" + (i+1) + ".gif";
    }
    return locations;
  },

  setupControls: function() {
    var self = this;
    var drag = new OpenLayers.Control.DragFeature(this.layer, {
      onComplete: function() {
        self.showActions();
      }
    });
    var tooltip = new OpenLayers.Control.SelectFeature(this.layer, {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function() {
        $("body").css({cursor: "pointer"});
      },
      outFeature: function() {
        $("body").css({cursor: "default"});
      }
    });

    var panZoom = new OpenLayers.Control.PanZoomBar();
    var scalebar = new OpenLayers.Control.ScaleLine();
    panZoom.zoomWorldIcon = true;
    var controls = [scalebar, tooltip, drag, new OpenLayers.Control.DragPan(), new OpenLayers.Control.Navigation(), panZoom];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  },

  setupFeatureLayer: function() {
    this.layer = new OpenLayers.Layer.Vector("Features");
    var style = new OpenLayers.Style({externalGraphic: '${thumbnail}', 'pointRadius': 9});
    var style_map = new OpenLayers.StyleMap({'default': style, 'select': style});
    this.layer.styleMap = style_map;
    this.map.addLayer(this.layer);
  }
});