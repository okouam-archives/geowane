
(function($) {

  Sammy = Sammy || {};

  Sammy.StatusWidget = function(app, name) {

    var template = $("#" + name);

    this.helpers({
      showStatusWidget: function(context) {
        jQuery.facebox(template.html());
        var facebox = $("#facebox .content");
        facebox.addClass(name).addClass("widget");
        facebox.find("a.cancel").click(function() {
          context.redirect("#/");
        });
        facebox.find("a.accept").click(function() {
          $(".status select").val(facebox.find("select").val());
          context.redirect("#/");
        });
      }
    });

  };

})(jQuery);