Spatial = Spatial || {};
Spatial.Models = Spatial.Models || {};

Spatial.Models.Settings = Class.extend({

  element: "map",

  iconPath: "/images/",

  urls: _.map(["http://geoserver1", "http://geoserver2", "http://geoserver3"], function(prefix) {
    return prefix + ".gowane.com/tilecache.py?";
  }),

  resolutions: [
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
        ],

  mapName: "geocms",

  mapOptions: {buffer: 0, maxExtent: new OpenLayers.Bounds(-13, 2, -1, 15), restrictedExtent: new OpenLayers.Bounds(-9, 4, -2, 11)},

  tileSize: 256,

  format: 'aggpng24',

  imageType: 'png',

  isTransparent: 'true',

  layers: ["kubudum"],

  reloadAttempts: 3,

  nativeImagesPath: "/images/OpenLayers/",

  roadStyle: {fill: true, stroke: true, fillColor: "#2356d9", strokeOpacity: 0.7, pointRadius: 4, strokeColor: "#2356d9", strokeWidth: 5},

  init: function(options) {
    $.extend(this, options);
    OpenLayers.ImgPath = this.nativeImagesPath;
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = this.reloadAttempts;
    if (options && options.minZoomLevel) {
      this.options.resolutions = this.resolutions.splice(options.minZoomLevel - 1);
    }
  }

});

