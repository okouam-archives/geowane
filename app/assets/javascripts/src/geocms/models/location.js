GeoCMS.Models.Location = Backbone.Model.extend({

  initialize: function() {
    this.comments = new GeoCMS.Collections.Comments({location: this});
    this.photos = new GeoCMS.Collections.Photos({location: this});
    this.info = new GeoCMS.Models.Info({location: this});
    this.logo = new GeoCMS.Models.Logo({location: this});;
    this.audits = new GeoCMS.Collections.Audits({location: this});
    this.geography = new GeoCMS.Models.Geography({location: this});
  },

  url: function() {
    return "/locations/" + this.id;
  }
});
