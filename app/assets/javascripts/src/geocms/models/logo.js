GeoCMS.Models.Logo = Backbone.Model.extend({

  initialize: function(options) {
    this.location = options.location;
  },

  url: function() {
    return "/locations/" + this.location.id + "/logo";
  }
});