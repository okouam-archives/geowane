$.Controller("LocationsCollectionEditCoordinates",
{
  "geocms.locations-retrieved subscribe": function(called, params) {
    this.displayLocations(params);
  },

  "geocms.locations-updated subscribe": function(called, params) {
    this.displayLocations(params);
  },

  "geocms.locations-updating subscribe": function() {
    this.loading = this.element.find(".portlet-content").busyBox({spinner: '<img src="/images/ajax-loader.gif" />'});
  },

  displayLocations: function(locations) {
    var table = this.element.find("tbody");
    table.empty();
    for(var i = 0; i < locations.length; i++){
      var location = locations[i];
      $("<tr><td>" + location.attributes.counter + "</td><td>"
              + location.attributes.name + "</td><td>" + Math.round(location.attributes.longitude * 100000) / 100000
              + "</td><td>" + Math.round(location.attributes.latitude * 100000) / 100000
              + "</td></tr>").appendTo(table);
    }
    table.find('tr:odd').css('background-color', '#fbfbfb');
    if (this.loading) this.loading.busyBox('close');
  }
});