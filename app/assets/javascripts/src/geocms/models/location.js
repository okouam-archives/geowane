GeoCMS.Models.Location = Backbone.Model.extend({

  initialize: function() {
    this.comments = new GeoCMS.Collections.Comments({location: this});
    this.coordinates = null;
    this.photos = null;
    this.info = new GeoCMS.Models.Info({location: this});
    this.logo = null;
    this.history = null;
    this.geography = new GeoCMS.Models.Geography({location: this});
  },

  url: function() {
    return "/locations/" + this.id;
  }
});
