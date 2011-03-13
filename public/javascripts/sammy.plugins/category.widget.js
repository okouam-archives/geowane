(function($) {

  Sammy = Sammy || {};

    var getSelected = function(widget) {
      return widget.find("select").val();
    };

  Sammy.CategoryWidget = function(app, renderData) {

    var widget;

    app.helpers({

      showCategoryWidget: function(context, url, text) {
        var html = JST['category_widget']({data: renderData, url: url, text: text});
        widget = context.openFaceboxWidget(html);
      },

      addCategory: function(context, locations, target) {
        $.ajax({
          url: "/locations",
          type: "PUT",
          data: {locations: locations, call: "add_tag", category: getSelected(widget)},
          success: function(updated) {
            _.each(updated, function(item) {
              var html = $(JST['tag_template'](item));
              var id = item.location_id;
              var wrapper = target(id);
              html.appendTo(wrapper).find("a.tag_delete").bind("ajax:complete", function() {
                $(this).parent().remove();
              });
            });
          }
        });
      },

      removeCategory: function(context, locations) {
        $.ajax({
          url: "/locations",
          type: "PUT",
          data: {locations: locations, call: "remove_tag", category: getSelected(widget)},
          success: function(updated) {
            _.each(updated, function(item) {
              context.getRow(item.location_id).find("span.list a[href$='" + item.tag_id + "']").parent().remove();
            });
          }
        });
      }
    });
  };

})(jQuery);