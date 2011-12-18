GeoCMS.Helpers.SortableTable = Backbone.View.extend({

  events: {
    "click th a": "sort"
  },

  sort: function() {
    var url = jQuery.param.querystring(window.location.href, {sort: $(this).data("sort"), page: 1});
    window.location = url;
  }

});

