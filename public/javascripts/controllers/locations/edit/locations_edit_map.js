$.Controller("LocationsEditMap",
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
    this.setupLandmarkLayer();
    this.setupControls();
    this.location_id = options.location_id;
    this.loadFeature(options.location_id);
  },

  loadFeature: function(location_id) {
    var self = this;
    $.getJSON("/locations/" + location_id,
      function(data) {
        self.display_location(data);
        self.original_geometry = self.layer.getDataExtent().getCenterLonLat();
        self.map.setCenter(self.original_geometry, 6);
        self.display_landmarks(location_id);
      }
    );
  },

  display_landmarks: function(location_id) {
    var self = this;
    $.getJSON("/landmarks/" + location_id,
      function(data) {
        var locations = new OpenLayers.Format.GeoJSON().read(data);
        for(var i = 0; i < locations.length; i++) {
          locations[i].attributes["thumbnail"] = "/images/" + locations[i].attributes["icon"]
        }
        self.landmark_layer.addFeatures(locations);
      }
    );
  },

  display_location: function(data) {
    var locations = new OpenLayers.Format.GeoJSON().read(data);
    for(var i = 0; i < locations.length; i++) {
      locations[i].attributes["thumbnail"] = "/icon/" + (i+1) + ".gif";
    }
    this.layer.addFeatures(locations);
  },

  "a:contains('Save') click": function() {
    this.publish("geocms.location-updating");
    this.original_geometry = this.layer.getDataExtent().getCenterLonLat();
    $.ajax({
      url: "/locations/" + this.location_id,
      data: {location: {id: this.location_id, longitude: this.original_geometry.lon, latitude: this.original_geometry.lat}},
      success: function(data) {
        this.original_geometry = this.layer.getDataExtent().getCenterLonLat();
        this.hideActions();
        this.publish("geocms.location-updated", data);
      },
      context: this,
      type: "PUT",
      dataType: "json"
    });
  },

  "a:contains('Cancel') click": function() {
    this.layer.features[0].move(this.original_geometry);
    this.hideActions();
  },

  showActions: function() {
    this.element.find(".portlet-header span").show();
  },

  hideActions: function() {
    this.element.find(".portlet-header span").hide();
  },

  setupControls: function() {
    var self = this;
    var drag = new OpenLayers.Control.DragFeature(this.layer, {
      onStart: function() {
        self.hideTipsy();
      },
      onComplete: function() {
        self.showActions();
      }
    });
    var tooltip = new OpenLayers.Control.SelectFeature([this.landmark_layer, this.layer], {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function(feature) {
        self.showLabel(feature);
        $("body").css({cursor: "pointer"});
      },
      outFeature: function() {
        $("body").css({cursor: "default"});
        self.hideTipsy();
      }
    });
    var panZoom = new OpenLayers.Control.PanZoomBar();
    panZoom.zoomWorldIcon = true;
    var scalebar = new OpenLayers.Control.ScaleLine();
    var controls = [scalebar, tooltip, drag, new OpenLayers.Control.DragPan(), new OpenLayers.Control.Navigation(), panZoom];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  },

  setupFeatureLayer: function() {
    this.layer = new OpenLayers.Layer.Vector("Features");
    var style = new OpenLayers.Style({externalGraphic: '${thumbnail}', 'pointRadius': 10});
    var style_map = new OpenLayers.StyleMap({'default': style, 'select': style});
    this.layer.styleMap = style_map;
    this.map.addLayer(this.layer);
  },

  setupLandmarkLayer: function() {
    this.landmark_layer = new OpenLayers.Layer.Vector("Landmarks");
    var style = new OpenLayers.Style({externalGraphic: '${thumbnail}', 'pointRadius': 10});
    var style_map = new OpenLayers.StyleMap({'default': style, 'select': style});
    this.landmark_layer.styleMap = style_map;
    this.map.addLayer(this.landmark_layer);
  },

  showLabel: function(feature){
    var coords = feature.layer.getViewPortPxFromLonLat(feature.geometry.bounds.getCenterLonLat());
    window["cancel.tipsy"] = true;
    var tip = window["active.tipsy"];
    if (!tip) {
        tip = $('<div class="tipsy"><div class="tipsy-inner"/></div>');
        tip.css({position: 'absolute', zIndex: 100000});
        window["active.tipsy"] = tip;
    }
    tip.find('.tipsy-inner')['html'](feature.attributes["name"]);
    var pos = {top: coords.y + 183, left: coords.x + 170, width: 24, height: 24};
    tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).appendTo(document.body);
    var actualWidth = tip[0].offsetWidth, actualHeight = tip[0].offsetHeight;
    tip.css({top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}).addClass('tipsy-south');
    tip.css({visibility: 'visible'});
  },

  hideTipsy: function () {
    window["cancel.tipsy"] = false;
    $("body").css({cursor: "default"});
    setTimeout(function() {
        if (window["cancel.tipsy"] || !window["active.tipsy"]) return;
        var tip = window["active.tipsy"];
        tip.remove();
    }, 100);
  }


});