(function($) {

  Sammy = Sammy || {};

  Sammy.CategoryWidget = function(app, name) {

    var template = $("#" + name);

    var getTagWrapper = function(location_id) {
      return $("tr[data-id=" + location_id + "] span.list");
    };

    var onFailure = function() {
      alert("The locations failed to be updated. Please contact the system administrator.");
    };

    this.helpers({

      showCategoryWidget: function(actionText, serverCall, onSuccess, context) {
        var overlay = context.openFaceboxWidget(template.html());
        overlay.find("a.accept").text(actionText + " Category").click(function() {
          $.ajax({
            url: "/locations",
            type: "PUT",
            data: {locations: context.getSelected(), call: serverCall, category: context.getSelectedCategory().id()},
            success: onSuccess,
            failure: onFailure
          });
          context.redirect("#/");
        });
      },

      getSelectedCategory: function() {
        return new Category({id: $("#category_id").val()});
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