GeoCMS.Views.LightboxLocationEditor = Backbone.View.extend({

  initialize: function() {
    $(this.el).find(".tab:not(:first)").hide();
    var location_id = $(this.el).find(".editor-content").data("id");
    new GeoCMS.Views.LightboxCommentEditor({el: "#comments.tab", id: location_id});
    new GeoCMS.Views.LightboxLogoEditor({el: "#logo.tab"});
    new GeoCMS.Views.LightboxPhotoEditor({el: "#photos.tab"});
    this.setupTabNavigation();
    this.setupSearchNavigation(location_id);
  },

  setupSearchNavigation: function(location_id) {
    $(this.el).find(".navigate-poi").click(function() {
      $("#facebox .content").css("text-align", "center");
      $("#facebox .content").html("<img class='loader' src='/assets/facebox/loading.gif' />");
      $.get($(this).attr("href"), function(html) {
        $("#facebox .content").css("text-align", "left");
        $("#facebox .content").html(html);
        var editor = window["location-editor"];
        editor.id = location_id;
        editor.render();
      });
      return false;
    })
  },

  setupTabNavigation: function() {
    $(this.el).find("#tabs a").click(function() {
      var ref = $(this).attr("href").split('#')[1];
      $("#tabs li").removeClass("active");
      $(this).parents("li").addClass("active");
      $(".tab:not(#" + ref + ")").hide();
      $("#" + ref).show();
      return false;
    })
  }
});