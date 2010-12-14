var SimpleMap = Class.extend({

  // constructor

  init: function(mapElement, observer, options) {
    this.ICON_PATH =  "/images/";
    this.URLS = [
      "http://geoserver1.gowane.com/tilecache.py?",
      "http://geoserver2.gowane.com/tilecache.py?",
      "http://geoserver3.gowane.com/tilecache.py?"
    ];
    this.RESOLUTIONS = [
      0.0125,
      0.00625,
      0.003125,
      0.0015625,
      0.00078125,
      0.000390625,
      0.0001953125,
      0.00009765625,
      0.000048828125,
      0.0000244140625,
      0.00001220703125,
      0.00000610351563
    ];
    this.MAP_OPTIONS = {
      buffer: 0,
      maxExtent: new OpenLayers.Bounds(-13, 2, -1, 15),
      restrictedExtent: new OpenLayers.Bounds(-9, 4, -2, 11)
    };
    this.FORMAT = 'aggpng24';
    this.IMAGE_TYPE = 'png';
    this.IS_TRANSPARENT = 'true',
    this.MAPSERVER_LAYERS = "land-basemap,water-basemap,road-labels,water-linestring,land-polygon,building-polygon,"
            + "manmade-polygon,sport-polygon,roads-far,roads-close,railways,cities,borders";
    this.TILECACHE_LAYER = "kubudum";
    this.ROAD_STYLE = {
      fill: true,
      stroke: true,
      fillColor: "#2356d9",
      strokeOpacity: 0.7,
      pointRadius: 4,
      strokeColor: "#2356d9",
      strokeWidth: 5
    };
    this.observer = observer;
    if (options) {
      if (options.minZoomLevel) this.RESOLUTIONS = this.RESOLUTIONS.splice(options.minZoomLevel - 1);
    }
    OpenLayers.ImgPath = "/images/OpenLayers/";
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;

    this.map = new OpenLayers.Map(mapElement, this.MAP_OPTIONS);
    this.createBaseLayer("Roads");
    this.setupControls();
    this.map.events.on({ "zoomend": this.raiseZoomChanged, scope: this });
    this.showFullExtent();
    this.raiseZoomChanged();
  },

  // public

  getCenter: function() {
    return this.map.getCenter();
  },

  showFullExtent: function() {
    this.map.setCenter(new OpenLayers.LonLat(-4.02054977, 5.32823992), 0, false, false);
    this.map.zoomToMaxExtent();
  },

  insertRouteFeature: function(road, replacePrevious, onComplete) {
    if (replacePrevious) this.map.getLayer("default").destroyFeatures();
    var newFeatureGeometry = OpenLayers.Geometry.fromWKT(road.geometry);
    var newFeature = new OpenLayers.Feature.Vector(newFeatureGeometry, road, this.ROAD_STYLE);
    this.features.addFeatures([newFeature], {silent: false});
    if (onComplete) onComplete();
  },

  zoomToFeatures: function(layer_id) {
    var bounds = this.map.getLayer(layer_id).getDataExtent();
    if (bounds) this.map.zoomToExtent(bounds);
  },

  removeLayer: function(layer_id) {
    var layer = this.map.getLayer(layer_id);
    if (layer) {
      this.map.removeLayer(layer);
    }
  },

  displayFeatures: function(locations, layer_id, onComplete) {
    var layer = this.map.getLayer(layer_id);
    if (!layer) layer = this.createVectorLayer(layer_id);
    var newFeatures = [];
    for (var i = 0; i < locations.length; i++) {
      var location = locations[i];
      newFeatures.push(this.createFeature(location));
    }
    layer.addFeatures(newFeatures, {silent: false});
    if (onComplete) onComplete();
  },

  displayDraggableFeatures: function(locations, layer_id, onComplete) {
    var layer = this.map.getLayer(layer_id);
    if (!layer) layer = this.createVectorLayerWithDraggables(layer_id);
    this.addFeaturesToLayer(locations, layer, onComplete);
  },

  displayFeaturesWithPopups: function(locations, layer_id, onComplete) {
    var layer = this.map.getLayer(layer_id);
    if (!layer) layer = this.createVectorLayerWithPopups(layer_id);
    this.addFeaturesToLayer(locations, layer, onComplete);
  },

  // private

  addFeaturesToLayer: function(locations, layer, onComplete) {
    var newFeatures = [];
    for (var i = 0; i < locations.length; i++) {
      var location = locations[i];
      newFeatures.push(this.createFeature(location));
    }
    layer.addFeatures(newFeatures, {silent: false});
    if (onComplete) onComplete();
  },

  createVectorLayerWithPopups: function(id) {
    var container = this.createVectorLayer(id);
    var selector = new OpenLayers.Control.SelectFeature(container, { multiple: false, hover: true });
    this.map.addControl(selector);
    selector.activate();
    var self = this;
    container.events.on({
      'featureselected': function(evt) {
        self.onFeatureSelect(evt.feature, self.map);
      },
      'featureunselected': function(evt) {
        self.onFeatureUnselect(evt.feature, self.map);
      }
    });
    return container;
  },

  createVectorLayerWithDraggables: function(id) {
    var layer = this.createVectorLayer(id);
    var dragFeature = new OpenLayers.Control.DragFeature(layer);
    dragFeature.onStart = function() {
      document.body.style.cursor = 'pointer';
    };
    dragFeature.onComplete = this.onDragFeatureComplete.bind(this);
    dragFeature.documentDrag = true;
    this.map.addControl(dragFeature);
    dragFeature.activate();
    return layer;
  },


  onFeatureSelect: function(feature, map) {
    var attributes = feature.attributes;
    if (!attributes.label) return;
    var coordinates = feature.geometry.getBounds().getCenterLonLat();
    var resolution = map.getResolution();
    var newCoordinates = new OpenLayers.LonLat(coordinates.lon + resolution * - 75, coordinates.lat + resolution * 70);
    var size = new OpenLayers.Size(200, 20);
    var name = attributes.label;
    var contents = "<b>" + name + "</b>";
    if (attributes.category && attributes.commune) {
      contents = contents + "<br/>" + attributes.category + ", " + attributes.commune;
    }
    feature.popup = new OpenLayers.Popup(name, newCoordinates, size, contents);
    feature.popup.feature = feature;
    this.map.addPopup(feature.popup);
    feature.popup.updateSize();
  },

  onFeatureUnselect: function(feature, map) {
    if (feature.popup) {
      feature.popup.feature = null;
      map.removePopup(feature.popup);
      feature.popup.destroy();
      feature.popup = null;
    }
  },

  raiseZoomChanged: function() {
    if (this.observer && this.observer.onZoomChanged) this.observer.onZoomChanged(this.map.getExtent());
  },

  createBaseLayer: function(name) {
    var layerOptions = {
      resolutions: this.RESOLUTIONS,
      isBaseLayer: true,
      buffer: 0
    }
    var renderOptions = this.setRenderingOptions();
    this.map.addLayer(new OpenLayers.Layer.WMS(name, this.URLS, renderOptions, layerOptions));
  },

  setRenderingOptions: function() {
    var options = {
      map_imagetype: this.IMAGE_TYPE,
      format: this.FORMAT,
      transparent: this.IS_TRANSPARENT,
      tileSize: this.TILE_SIZE,
      buffer: 0
    };
    options.layers = this.TILECACHE_LAYER;
    return options;
  },

  createVectorLayer: function(id) {
    var layer = new OpenLayers.Layer.Vector(id, {"reportError": true });
    layer.id = id;
    this.map.addLayer(layer);
    return layer;
  },

  onDragFeatureComplete: function(feature, pixel) {
    document.body.style.cursor = 'auto';
    if (this.observer.onDragComplete) this.observer.onDragComplete(feature, this.map.getLonLatFromPixel(pixel));
  },

  setupControls: function() {
    this.map.removeControl(this.map.getControlsByClass("OpenLayers.Control.PanZoom")[0]);
    this.map.addControl(new OpenLayers.Control.ScaleLine());
    this.map.addControl(new OpenLayers.Control.PanZoomBar());
  },

  createFeature: function(location) {
    if (location.feature.startsWith("POINT")) {
      var newFeatureGeometry = new OpenLayers.Geometry.Point(location.longitude, location.latitude);
      var graphic = this.ICON_PATH + location.icon;
      var pointRadius = 12;
      if (location.size) pointRadius = location.size;
      var rendering = { externalGraphic: graphic, pointRadius: pointRadius, graphicYOffset: -pointRadius};
      return new OpenLayers.Feature.Vector(newFeatureGeometry, location, rendering);
    } else {
      var newFeatureGeometry = OpenLayers.Geometry.fromWKT(location.feature);
      return new OpenLayers.Feature.Vector(newFeatureGeometry, location, MapFeaturesController.ROAD_STYLE);
    }
  }

});