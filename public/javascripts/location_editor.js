var LocationEditor = Class.extend({

  init: function(options) {

    this.options = options;
    
    $(document).bind("load.location.comments", this.loadComments.bind(this));

    $(document).bind("load.location.tags", this.loadTags.bind(this));

    var observer = {
      onDragComplete: function(feature, lonlat) {
        $("#location_latitude").val(lonlat.lat);
        $("#location_longitude").val(lonlat.lon);
      },
      onZoomChanged: function(extent) {}
    };  
      
    this.map = new SingleFeatureMap({element: "map", observer: observer});
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
