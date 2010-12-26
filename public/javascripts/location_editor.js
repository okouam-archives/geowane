var LocationEditor = Class.extend({

  init: function(options) {

    this.options = options;
    
    $(document).bind("load.location.comments", this.loadComments.bind(this));

    $(document).bind("load.location.tags", this.loadTags.bind(this));

    var options = {
      observer: {
        onDragComplete: function(feature, lonlat) {
          $("#location_latitude").val(lonlat.lat);
          $("#location_longitude").val(lonlat.lon);
        },
        onZoomChanged: function(extent) {}
      }, 
      element: "map",
      urls: ["http://xkcd.codeifier.com/cgi-bin/mapserv?map=/var/www/mapserver/mapfiles/geocms.map"],
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
       mapOptions: {
        bounds: 0,
        maxExtent: new OpenLayers.Bounds(-25, -5, 15, 25),
        restrictedExtent: new OpenLayers.Bounds(-20, 0, 10, 20)
      },
      layers: ["road-labels", "countries", "water", "roads-other", "roads-type-5", "roads-type-4", "roads-type-3", 
        "roads-type-2", "roads-type-1"]
    };
      
    this.map = new SingleFeatureMap(options);
    this.showCurrentLocation(function() {this.map.zoomToFeatures("default");}.bind(this));

    $("#edit-location-tabs").tabs();

    $("input[name='show_landmarks']").change(function(){
      if ($("input[name='show_landmarks']:checked").val() == '0') this.map.removeLayer("landmarks");
      else this.showLandmarks();
    }.bind(this));    

    $(document).trigger("load.location.tags");
    $(document).trigger("load.location.comments");

    $(".save").click(function() {
      $(".block form").submit();
    });
  }, 

  loadTags: function() {
    this.options.tagsContainer.load(this.options.tagsFetchUrl);
  },

  loadComments: function() {
    this.options.commentsContainer.load(this.options.commentsFetchUrl);
  },

  showLandmarks: function() {
    $.ajax({
      type: "GET",
      dataType: "json",
      data: {
        "bounds[]": this.map.map.getExtent().toArray(),
      },
      url: "/locations/" + this.options.locationId + "/surrounding_landmarks",
      success: function(points) {
        this.map.displayFeaturesWithPopups(points, "landmarks");
      }.bind(this)
    });
  },

  showCurrentLocation: function(func) {
    var onSuccess = function(msg) {
      poi = eval("(" + msg + ")");
      poi.icon = "/shape_square_purple.png";
      this.map.removeLayer("default");
      if (func) {
        this.map.displayDraggableFeatures([poi], "default", func);
      } else {
        this.map.displayDraggableFeatures([poi], "default");
      }
    };  
    $.ajax({ type: "GET", dataType : 'script', url: "/locations/" + this.options.locationId, success: onSuccess.bind(this) });    
  }        
});
