GeoCMS.Models.Geography = Backbone.Model.extend({

  initialize: function(options) {
    this.location = options.location;
  },

  parse: function(response) {
    if (response.boundary_0) {
      response.boundary_0 = this.processBoundary(response.boundary_0);
    }
    if (response.boundary_1) {
      response.boundary_1 = this.processBoundary(response.boundary_1);
    }
    if (response.boundary_2) {
      response.boundary_2 = this.processBoundary(response.boundary_2);
    }
    if (response.boundary_3) {
      response.boundary_3 = this.processBoundary(response.boundary_3);
    }
    if (response.boundary_4) {
      response.boundary_4 = this.processBoundary(response.boundary_4);
    }
    return response;
  },

  processBoundary: function(boundary) {
    var parts = boundary.split(/=>/);
    return {
      classification: parts[0].replace(/"/, "").replace(/"/, ""),
      name: parts[1].replace(/"/, "").replace(/"/, "")
    }
  },

  url: function() {
    return "/api/locations/" + this.location.id + "/geography";
  }
});