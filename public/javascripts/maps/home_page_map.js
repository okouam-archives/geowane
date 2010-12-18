var HomePageMap = SimpleMap.extend({

  init: function(mapElement, observer, options) {
    this._super(mapElement, observer, options);
  },

  addFeatureLayer: function() {
    var container = this._super();
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
  }
});

