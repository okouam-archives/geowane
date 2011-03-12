
(function($) {

  Sammy = Sammy || {};

  Sammy.StatusWidget = function(app, renderData) {

    var widget;

    this.helpers({

      showStatusWidget: function(context) {
        var html = JST['status_widget']({data: renderData});
        widget = context.openFaceboxWidget(html);
      },

      changeStatus: function(context, locations) {
        _.each(locations, function(location_id) {
          context.getRow(location_id).find(".status select").val(widget.find("select").val());
        });
      }
    });

  };

})(jQuery);