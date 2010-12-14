/**
 *  Implementation of a Single Feature Map
 *    - mapElement
 *    The jQuery element inside which the map will be displayed
 *    - observer
 *    An object containing a set of callbacks for Single Feature Maps.
 *    - options
 *    Options for the map
 */

var SingleFeatureMap = SimpleMap.extend({

  init: function(mapElement, observer, options) {
    this._super(mapElement, observer, options);
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
    if (this.observer.onDragComplete) this.observer.onDragComplete(feature, this.map.getLonLatFromPixel(pixel));
  }

});