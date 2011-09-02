$.Class.extend('Carto',
{
  build: function() {
    OpenLayers.ImgPath = "/assets/images/OpenLayers/";
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
    return this.map;
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
    var pos = {top: coords.y + 173, left: coords.x + 160, width: 24, height: 24};
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
  },

  addCommonControls: function(map) {
    var panZoom = new OpenLayers.Control.PanZoomBar();
    panZoom.zoomWorldIcon = true;
    var controls = [
      new OpenLayers.Control.ScaleLine(),
      new OpenLayers.Control.DragPan(),
      new OpenLayers.Control.Navigation(),
      panZoom
    ];
    map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  },

  displayNumberedFeaturesById: function(data, layer) {
    var geojson_format = new OpenLayers.Format.GeoJSON();
    var locations = geojson_format.read(data);
    for(var i = 0; i < locations.length; i++) {
      locations[i].attributes["counter"] = (i+1);
      locations[i].attributes["thumbnail"] = "/assets/images/icons/" + (i+1) + ".gif";
    }
    layer.addFeatures(locations);
    layer.map.zoomToExtent(layer.getDataExtent());
  },

  displayNumberedFeatures: function(features, layer) {
    for(var i = 0; i < features.length; i++) {
      features[i].attributes["counter"] = (i+1);
      features[i].attributes["thumbnail"] = "/assets/images/icons/" + (i+1) + ".gif";
    }
    layer.addFeatures(features);
    layer.map.zoomToExtent(layer.getDataExtent());
  },

  displayLandmarkFeatures: function(location_id, layer) {
    $.getJSON("/landmarks/" + location_id,
      function(data) {
        var locations = new OpenLayers.Format.GeoJSON().read(data);
        for(var i = 0; i < locations.length; i++) {
          locations[i].attributes["thumbnail"] = "/assets/images/" + locations[i].attributes["icon"]
        }
        layer.addFeatures(locations);
      }
    );
  },

  createLayer: function(name, map) {
    var layer = new OpenLayers.Layer.Vector(name);
    var style = new OpenLayers.Style({externalGraphic: '${thumbnail}', 'pointRadius': 9});
    var style_map = new OpenLayers.StyleMap({'default': style, 'select': style});
    layer.styleMap = style_map;
    map.addLayer(layer);
    return layer;
  }
},
{
  // no instance methods
});