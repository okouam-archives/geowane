$.Controller("Search",
{
  init: function(el) {
  },

  ".aoq-wrapper click": function() {
    $("#advanced").show();
    $(".aoq-wrapper").css("visibility", "hidden");
  },

  "a.close-button click": function() {
    $("#advanced").hide();
    $(".aoq-wrapper").css("visibility", "visible");
  }

});
