$.Controller("LocationsEditMap",
{
  init: function(el, options) {
    OpenLayers.ImgPath = "/images/OpenLayers/";
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
    this.map = new OpenLayers.Map("mappanel", {
        theme: null,
        maxResolution: 0.703125,
        maxExtent: new OpenLayers.Bounds(-62.6428949, -11.4905018, 49.85710501, 35.844773),
        controls: []
    });
    this.map.addLayer(new OpenLayers.Layer.WMS("base", ["http://moussa.0-one.net/tilecache.py?"], {layers: "data01", format: "image/png"}));
    this.setupFeatureLayer();
    this.setupControls();
    this.location_id = options.location_id;
    this.loadFeature(options.location_id);
  },

  loadFeature: function(location_id) {
    var self = this;
    $.getJSON("/features/" + location_id,
      function(data) {
        var geojson_format = new OpenLayers.Format.GeoJSON();
        var locations = geojson_format.read(data);
        self.layer.addFeatures(locations);
        self.original_geometry = self.layer.getDataExtent().getCenterLonLat();
        self.map.setCenter(self.original_geometry, 6);
      }
    );
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
      onComplete: function() {
        self.showActions();
      }
    });
    var panZoom = new OpenLayers.Control.PanZoomBar();
    panZoom.zoomWorldIcon = true;
    var controls = [drag, new OpenLayers.Control.DragPan(), new OpenLayers.Control.Navigation(), panZoom];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  },

  setupFeatureLayer: function() {
    this.layer = new OpenLayers.Layer.Vector("Features");
    var style = new OpenLayers.Style({'fillColor': '#66C17B', 'fillOpacity': 0.6, 'pointRadius': 6, 'strokeWidth': 1, 'strokeColor': '#000'});
    var style_map = new OpenLayers.StyleMap({'default': style});
    this.layer.styleMap = style_map;
    this.map.addLayer(this.layer);
  }
});