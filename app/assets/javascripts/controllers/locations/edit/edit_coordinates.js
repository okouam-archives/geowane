$.Controller("EditCoordinates",
{
  "geocms.location-updated subscribe": function(called, params) {
    var boundaryWrapper = this.element.find("ul").eq(0);
    boundaryWrapper.empty();
    for(var i= 0; i < 5; i++) {
      var boundary = params.properties.boundaries[i];
      if (boundary) {
       $("<li><label>" + boundary.classification + "</label>" + boundary.name + "</li>").appendTo(boundaryWrapper);
      }
    }
    var lonlat = this.element.find("ul").eq(1);
    lonlat.find("li").eq(0).find("span").text(params.properties.latitude);
    lonlat.find("li").eq(1).find("span").text(params.properties.longitude);
    this.loading.busyBox('close');
  },

  "geocms.location-updating subscribe": function() {
    this.loading = this.element.find(".portlet-content").busyBox({spinner: '<img src="/assets/images/ajax-loader.gif" />'});
  }
});