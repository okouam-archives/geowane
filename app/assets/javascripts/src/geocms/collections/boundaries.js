var GeoCMS = GeoCMS || {};
GeoCMS.Collections = GeoCMS.Collections || {};

GeoCMS.Collections.Boundaries = Backbone.Collection.extend({

  model: GeoCMS.Models.Boundary,

  fetch: function(level, callback) {
    $.ajax({
      url: "/boundaries/" + level,
      type: "GET",
      dataType: "json",
      success:  callback
    });
  }
});