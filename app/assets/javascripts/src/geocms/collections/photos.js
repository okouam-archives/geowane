GeoCMS.Collections.Photos = Backbone.Collection.extend({

  model: GeoCMS.Models.Photo,

  initialize: function(options) {
    this.location = options.location;
  },

  url: function() {
    return "/locations/" + this.location.id + "/photos";
  }

});