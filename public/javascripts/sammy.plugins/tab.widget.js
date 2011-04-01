(function($) {

  Sammy = Sammy || {};

  Sammy.TabWidget = function(app, links) {

    var tabs = _.map(links, function(item) {
      var href = $(item).attr("href");
      var startIndex = href.lastIndexOf("/") + 1;
      var name = href.substring(startIndex);
      return $("#" + name + "-tab");
    });

    var anchors = links;

    this.helpers({

      showTab: function(name) {
        _.each(anchors, function(anchor) {
          if ($(anchor).hasClass("selected")) $(anchor).removeClass("selected");
        });

        _.each(tabs, function(item) {
          item.hide();
        });

        var link = _.select(links, function(candidate) {
          return $(candidate).attr("href") == "#/tab/" + name;
        });
        $(link).addClass("selected");

        var active = _.select(tabs, function(item) {
          return item.attr("id") == name + "-tab";
        });
        active[0].show();
      }

    });

  };

})(jQuery);