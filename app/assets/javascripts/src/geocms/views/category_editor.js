GeoCMS.Views.CategoryEditor = Backbone.View.extend({

  initialize: function() {
    new GeoCMS.Helpers.DataTable({el: this.el});
  }
});
