Spatial = Spatial || {};
Spatial.Models = Spatial.Models || {};

Spatial.Models.Map = Class.extend({

  init: function(settings) {
    this.opts = settings;
    this.instance = new OpenLayers.Map(this.opts.element, this.opts.mapOptions);
    this.view = new Spatial.Models.View(this.instance);
    this.createBaseLayer(this.opts.mapName);
    this.setupControls();
    this.view.showFullExtent();
  },

  // public

  zoomToFeatures: function(layer_id) {
    var bounds = this.instance.getLayer(layer_id).getDataExtent();
    if (bounds) this.instance.zoomToExtent(bounds);
  },

  removeLayer: function(layer_id) {
    var layer = this.instance.getLayer(layer_id);
    if (layer) this.instance.removeLayer(layer);
  },

  displayFeatures: function(locations, layer_id, onComplete) {
    var layer = this.instance.getLayer(layer_id) || this.createVectorLayer(layer_id);
    return this.addFeaturesToLayer(locations, layer, onComplete);
  },

  displayDraggableFeatures: function(locations, layer_id, onComplete) {
    var layer = this.instance.getLayer(layer_id) || this.createVectorLayerWithDraggables(layer_id);
    this.addFeaturesToLayer(locations, layer, onComplete);
  },

  displayFeaturesWithPopups: function(locations, layer_id, onComplete) {
    var layer = this.instance.getLayer(layer_id) || this.createVectorLayerWithPopups(layer_id);
    this.addFeaturesToLayer(locations, layer, onComplete);
  },

  // private

  addFeaturesToLayer: function(locations, layer, onComplete) {
    var features = _.map(locations, function(location) {
      return new Spatial.Models.Feature(location.longitude, location.latitude, this.opts.iconPath + location.icon);
    });
    layer.addFeatures(features, {silent: false});
    if (onComplete) onComplete();
  },

  createVectorLayerWithPopups: function(id) {
    var container = this.createVectorLayer(id);
    var selector = new OpenLayers.Control.SelectFeature(container, { multiple: false, hover: true });
    this.instance.addControl(selector);
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
    this.instance.addControl(dragFeature);
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
    this.instance.addPopup(feature.popup);
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

  createBaseLayer: function(name) {
    var layerOptions = {
      resolutions: this.opts.resolutions,
      isBaseLayer: true,
      buffer: 0
    };
    var renderOptions = this.setRenderingOptions();
    this.instance.addLayer(new OpenLayers.Layer.WMS(name, this.opts.urls, renderOptions, layerOptions));
  },

  setRenderingOptions: function() {
    var options = {
      map_imagetype: this.opts.imageType,
      format: this.opts.format,
      transparent: this.opts.isTransparent,
      tileSize: this.opts.tileSize,
      buffer: 0
    };
    options.layers = this.opts.layers;
    return options;
  },

  createVectorLayer: function(id) {
    var layer = new OpenLayers.Layer.Vector(id, {"reportError": true });
    layer.id = id;
    this.instance.addLayer(layer);
    return layer;
  },

  onDragFeatureComplete: function(feature, pixel) {
    document.body.style.cursor = 'auto';
    if (this.opts.observer.onDragComplete) this.opts.observer.onDragComplete(feature, this.map.getLonLatFromPixel(pixel));
  },

  setupControls: function() {
    this.map.removeControl(this.map.getControlsByClass("OpenLayers.Control.PanZoom")[0]);
    this.map.addControl(new OpenLayers.Control.ScaleLine());
    this.map.addControl(new OpenLayers.Control.PanZoomBar());
  }

});

