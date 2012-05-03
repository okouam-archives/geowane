GeoCMS.Helpers.LightboxEditor = Backbone.View.extend({

  setupTabNavigation: function(wrapper) {
    wrapper.find(".tab:first").show();
    $("#tabs li").removeClass("active");
    wrapper.find("#tabs a:first").parents("li").addClass("active");
    wrapper.find(".tab:not(:first)").hide();

    wrapper.find("#tabs a").click(function() {
      var ref = $(this).attr("href").split('#')[1];
      $("#tabs li").removeClass("active");
      $(this).parents("li").addClass("active");
      $(".tab:not(#" + ref + ")").hide();
      $("#" + ref).show();
      return false;
    })
  }

});