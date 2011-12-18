GeoCMS.Views.LocationSearch = Backbone.View.extend({

  events: {
    "click .aoq-wrapper": "show",
    "click .more-search": "expand",
    "click a.close-button": "hide"
  },

  initialize: function() {
    $("#s_added_after").date_input();
    $("#s_added_before").date_input();
    $("#s_modified_after").date_input();
    $("#s_modified_before").date_input();
  },

  show: function() {
    $("#advanced").show();
    $(".aoq-wrapper").css("visibility", "hidden");
  },

  hide: function() {
    $("#advanced").hide();
    $(".aoq-wrapper").css("visibility", "visible");
  },

  expand: function(evt) {
    var button = $(evt.target);
    var complex_search_panel = $(this.el).find(".complex-search");
    var current_text = button.html();
    if (current_text == "More Search Options") {
      complex_search_panel.show();
      button.html("Less Search Options");
    } else {
      complex_search_panel.hide();
      button.html("More Search Options");
    }
  }

});