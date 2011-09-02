
(function($) {

  Sammy = Sammy || {};

  Sammy.FaceboxWidget = function(app, name) {

    this.helpers({

      closeFacebox: function() {
        $(document).trigger('close.facebox');
      },

      openFaceboxWidget: function(options, klass) {
        jQuery.facebox(options);
        var overlay = $("#facebox .content");
        overlay.find("a.cancel").click(function() {this.redirect("#/")}.bind(this));
        if (klass) overlay.addClass(klass);
        return overlay.addClass("widget");
      }

    });

  };

})(jQuery);