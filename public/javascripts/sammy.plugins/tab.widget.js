(function($) {

  Sammy = Sammy || {};

  Sammy.TabWidget = function(app, links) {

    var tabs = _.map(links, function(item) {
      var href = $(item).attr("href");
      var startIndex = href.lastIndexOf("/") + 1;
      var name = href.substring(startIndex);
      return $("#" + name + "-tab");
    });

    this.helpers({

      showTab: function(name) {
        _.each(tabs, function(item) {
          item.hide();
        });
        var active = _.select(tabs, function(item) {
          return item.attr("id") == name + "-tab";
        });
        active[0].show();
      }

    });

  };

})(jQuery);