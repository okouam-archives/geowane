$.Controller("LocationsIndexMap",
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
    this.loadFeatures(options);
  },

  loadFeatures: function(locations) {
    var self = this;
    $.getJSON("/locations/" + locations,
      function(data) {
        var geojson_format = new OpenLayers.Format.GeoJSON();
        var locations = geojson_format.read(data);
        for(var i = 0; i < locations.length; i++) {
          locations[i].attributes["counter"] = (i+1);
          locations[i].attributes["thumbnail"] = "/icon/" + (i+1) + ".gif";
        }
        self.layer.addFeatures(locations);
        self.map.zoomToExtent(self.layer.getDataExtent());
        self.publish("geocms.locations-retrieved", locations);
      }
    );
  },

  hideTipsy: function () {
    window["cancel.tipsy"] = false;
    $("body").css({cursor: "default"});
    setTimeout(function() {
        if (window["cancel.tipsy"] || !window["active.tipsy"]) return;
        var tip = window["active.tipsy"];
        tip.remove();
    }, 100);
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
    var pos = {top: coords.y + 189, left: coords.x + 170, width: 24, height: 24};
    tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).appendTo(document.body);
    var actualWidth = tip[0].offsetWidth, actualHeight = tip[0].offsetHeight;
    tip.css({top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}).addClass('tipsy-south');
    tip.css({visibility: 'visible'});
  },

  setupControls: function() {
    var self = this;
    var tooltip = new OpenLayers.Control.SelectFeature(this.layer, {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function(feature) {
        self.showLabel(feature);
      },
      outFeature: function() {
        self.hideTipsy();
      }
    });
    var panZoom = new OpenLayers.Control.PanZoomBar();
    panZoom.zoomWorldIcon = true;
    var scalebar = new OpenLayers.Control.ScaleLine();
    var controls = [tooltip, new OpenLayers.Control.DragPan(), scalebar, new OpenLayers.Control.Navigation(), panZoom];
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