GeoCMS.Views.LocationSearch = Backbone.View.extend({

  events: {
    "click .aoq-wrapper": "show",
    "click .more-search": "expand",
    "click a.close-button": "hide",
    "click button.search-button": "search"
  },

  initialize: function(options) {
    this.criteria = criteria = options.locations.criteria;
    $("#s_added_after").date_input();
    $("#s_added_before").date_input();
    $("#s_modified_after").date_input();
    $("#s_modified_before").date_input();
    $("form.search button.search-button").click(function() {
      var input = $("#query");
      criteria.set({name: input.val(), page: 1});
      input.val("");
      return false;
    })
  },

  search: function() {
    var name = $("#s_name").val();
    var street_name = $("#s_street_name").val();
    var country = $("#s_level_id").val();
    var categories = $("#s_category_id").val();
    var status = $("#s_status").val();
    var added_before = $("#s_added_before").val();
    var added_by = $("#s_added_by").val();
    var added_after = $("#s_added_after").val();
    var modified_by = $("#s_modified_by").val();
    var modified_before = $("#s_modified_before").val();
    var modified_after = $("#s_modified_after").val();
    var criteria = {
      name: name != "" ? name : "",
      street_name: street_name != "" ? street_name : "",
      level_id: country != "" ? country : "",
      category_id: categories != "" ? categories : "",
      status: status != "" ? status : "",
      added_before: added_before != "" ? added_before : "",
      added_after: added_after != "" ? added_after : "",
      added_by: added_by != "" ? added_by : "",
      modified_by: modified_by != "" ? modified_by : "",
      modified_before: modified_before != "" ? modified_before : "",
      modified_after: modified_after != "" ? modified_after : "",
      page: 1
    };
    this.criteria.set(criteria);
    this.hide();
    return false;
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