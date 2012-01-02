GeoCMS.Models.Search = Backbone.Model.extend({
  changePage: function(page) {
    this.set({page: page});
  }
});