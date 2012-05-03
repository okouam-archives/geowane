GeoCMS.Views.Users.SearchResults = Backbone.View.extend({

  events: {
    "click tr .name a": "show"
  },

  initialize: function() {
    $(document).bind('listing-updated', this.updateListing.bind(this));
  },

  updateListing: function(evt, id, name, status, city, longitude, lagitude, tags) {
    $row = $("table.main tr[data-id='" + id + "']");
    if ($row) {
      $cells = $row.find("td");
      $cells.eq(1).find("a").text(name);
      $cells.eq(2).text(city);
      $cells.eq(3).text(tags);
      $cells.eq(7).text(status);
    }
  },

  show: function(evt) {
    this.showEditor($(evt.target).data("id"));
    return false;
  },

  showEditor: function(user_id) {
    $(document).bind('afterReveal.facebox', function() {
      window.App.Lightbox = new GeoCMS.Views.Users.Lightbox.Editor({el: "#facebox", id: user_id});
      $(document).unbind('afterReveal.facebox');
    });
    $.facebox({ajax: "/users/" + user_id + "/edit"});
  }

});