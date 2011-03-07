// Requires jQuery.Templates

(function($) {

  Sammy = Sammy || {};

  Sammy.CategoryWidget = function(app, name) {

    var template = $("#" + name);

    var getTagWrapper = function(location_id) {
      return $("tr[data-id=" + location_id + "] span.list");
    };

    this.helpers({

      showCategoryWidget: function(actionText, serverCall, callback, context) {
        jQuery.facebox(template.html());
        var overlay = $("#facebox .content");
        overlay.addClass(name).addClass("widget");
        overlay.find("a.cancel").click(function() {
          context.redirect("#/");
        });
        overlay.find("a.accept").text(actionText + " Category").click(function() {
          $.ajax({
            url: "/locations",
            type: "PUT",
            data: {locations: context.getSelected(), call: serverCall, category: context.getSelectedCategory().id},
            success: callback,
            failure: function() {
              alert("The locations failed to be updated. Please contact the system administrator.");
            }
          });
          context.redirect("#/");
        });
      },

      getSelectedCategory: function() {
        return {id: $("#category_id").val(), name: "NAME"};
      },

      removeTag: function(item) {
        getTagWrapper(item.location_id).find("a[href$='" + item.tag_id + "']").parent().remove();
      },

      addTag: function(item) {
        var template = $(JST['tag_template'](item));
        var wrapper = getTagWrapper(item.location_id);
        template.appendTo(wrapper).find("a.tag_delete").bind("ajax:complete", function() {
          $(this).parent().remove();
        });
      }

    });

  };

})(jQuery);