GeoCMS.Collections.Audits = Backbone.Collection.extend({

  model: GeoCMS.Models.Photo,

  initialize: function(options) {
    this.location = options.location;
  },

  url: function() {
    return "/api/locations/" + this.location.id + "/audits";
  }

});