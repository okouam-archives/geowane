var SingleFeatureMap = SimpleMap.extend({

  init: function(options) {
    this._super(options);
    this.options = options;
  },

  addFeatureLayer: function() {
    var container = this._super();
    var dragFeature = new OpenLayers.Control.DragFeature(container);
    dragFeature.onStart = function() {
      document.body.style.cursor = 'pointer';
    };
    dragFeature.onComplete = this.onDragFeatureComplete.bind(this);
    dragFeature.documentDrag = true;
    this.map.addControl(dragFeature);
    dragFeature.activate();
    return container;
  },

  onDragFeatureComplete: function(feature, pixel) {
    document.body.style.cursor = 'auto';
    if (this.options.observer.onDragComplete) this.options.observer.onDragComplete(feature, this.map.getLonLatFromPixel(pixel));
  }

});
