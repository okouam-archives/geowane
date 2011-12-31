GeoCMS.Helpers.SortableTable = Backbone.View.extend({

  initialize: function(options) {
    this.callback = options.callback;
  },

  events: {
    "click th a": "sort"
  },

  sort: function(evt) {
    this.callback($(evt.target).data("sort"));
    return false;
  }

});

