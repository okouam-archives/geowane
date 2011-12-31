GeoCMS.Models.Info = Backbone.Model.extend({

  initialize: function(options) {
    this.location = options.location;
  },

  url: function() {
    return "/api/locations/" + this.location.id + "/info";
  }
});