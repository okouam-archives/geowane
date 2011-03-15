(function(window) {

  window.Spatial = window.Spatial || {};

  window.Spatial.Models = window.Spatial.Models || {};

  window.Spatial.Models.Settings = Class.extend({

    element: "map",

    iconPath: "/images/",

    urls: ["http://galileo.codeifier.com/cgi-bin/mapserv?map=/home/deployment/mapserver/mapfiles/geocms.map"],

    layers: ["road-labels", "countries", "water", "roads-other", "roads-type-5", "roads-type-4", "roads-type-3",
        "roads-type-2", "roads-type-1"],

    resolutions: [
        0.05,
        0.025,
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
        0.0000122070313,
        0.0000061035156,
    ],

    mapName: "geocms",

    mapOptions: {
            bounds: 0,
            maxExtent: new OpenLayers.Bounds(-25, -5, 15, 25),
            restrictedExtent: new OpenLayers.Bounds(-20, 0, 10, 20)
    },

    tileSize: 256,

    format: 'aggpng24',

    imageType: 'png',

    isTransparent: 'true',

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

})(window);


