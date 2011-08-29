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
    if (this.loading) this.loading.busyBox('close');
  }
});