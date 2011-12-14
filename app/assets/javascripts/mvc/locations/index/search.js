$.Controller("Search",
{
  init: function() {
    $("#s_added_after").date_input();
    $("#s_added_before").date_input();
    $("#s_modified_after").date_input();
    $("#s_modified_before").date_input();
  },

  ".aoq-wrapper click": function() {
    $("#advanced").show();
    $(".aoq-wrapper").css("visibility", "hidden");
  },

  "a.close-button click": function() {
    $("#advanced").hide();
    $(".aoq-wrapper").css("visibility", "visible");
  },

  ".more-search click": function(el) {
    var current_text = $(el).html();
    if (current_text == "More Search Options") {
      this.element.find(".complex-search").show();
      $(el).html("Less Search Options");
    } else {
      this.element.find(".complex-search").hide();
      $(el).html("More Search Options");
    }
  }

});