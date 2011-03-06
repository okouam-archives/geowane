
(function($) {

  Sammy = Sammy || {};

  Sammy.StatusWidget = function(app, name) {

    var template = $("#" + name);

    this.helpers({
      showStatusWidget: function(callback) {
        jQuery.facebox(template.html());
        var overlay = $("#facebox .content");
        overlay.addClass(name).addClass("widget");
        overlay.find("a.cancel").click(function() {
          $(document).trigger('close.facebox');
        });
        overlay.find("a.accept").click(function() {
          $(".status select").val(overlay.find("select").val());
          callback();
        });
      }
    });

  };

})(jQuery);