GeoCMS.Views.Lightbox.Editor = Backbone.View.extend({

  events: {
    "click .previous": "previous",
    "click .next": "next"
  },

  initialize: function(options) {
    if (!options.current) throw new Exception("No current location was passed to the Lightbox Editor");
    if (!options.collection) throw new Exception("No current location was passed to the Lightbox Editor");
    this.commentEditor= new GeoCMS.Views.Lightbox.CommentEditor({el: "#comments.tab", location: options.current});
    this.mapEditor = new GeoCMS.Views.Lightbox.MapEditor({el: "#geography.tab", location: options.current});
    this.infoEditor = new GeoCMS.Views.Lightbox.InfoEditor({el: "#info.tab", location: options.current});
    this.photoEditor = new GeoCMS.Views.Lightbox.PhotoEditor({el: "#photos.tab", location: options.current});
    this.logoEditor = new GeoCMS.Views.Lightbox.LogoEditor({el: "#photos.tab", location: options.current});
    this.associate(options.current, options.collection);
  },

  associate: function(current, collection) {
    if (this.current) this.current.unbind("change");
    this.current = current;
    if (collection) this.locations = collection;
    this.mapEditor.associate(current);
    this.commentEditor.associate(current);
    this.infoEditor.associate(current);
    this.current.unbind("change");
    this.current.bind("change", this.render, this);
  },

  previous: function() {
    var currentIndex = _.indexOf(this.locations.pluck("id"), this.current.id);
    if (currentIndex == 0) currentIndex = this.locations.length;
    var newCurrent = this.locations.at(currentIndex - 1);
    this.associate(newCurrent);
    this.current.change();
    return false;
  },

  next: function() {
    var currentIndex = _.indexOf(this.locations.pluck("id"), this.current.id);
    if (currentIndex == (this.locations.length - 1)) currentIndex = -1;
    var newCurrent = this.locations.at(currentIndex + 1);
    this.associate(newCurrent);
    this.current.change();
    return false;
  },

  showWarning: function() {
    $("#geography .warning").html("The location has been modified. Click 'Accept' to keep changes.").show();
  },

  render: function() {
    $(this.el).find("span.location_name").text(this.current.get("name"));

    var name_input = $(this.el).find("#basic #name");
    name_input.val(this.current.get("name"));

    var city_selector = $(this.el).find("#basic #city");
    var city_id = city_selector.find("option:contains('" + this.current.get("city") + "')").val();
    city_selector.val(city_id);

    var status_selector = $(this.el).find("#basic #status");
    var status_id = status_selector.find("option:contains('" + this.current.get("status") + "')").val();
    status_selector.val(status_id);

    $(this.el).find("input").bind('input', function() {
      this.showWarning();
    }.bind(this));

    $(this.el).find("select").change(function() {
      this.showWarning();
    }.bind(this));

    this.current.comments.fetch();
    this.current.info.fetch();
    this.current.geography.fetch({success: function() {
      this.current.geography.change();
    }.bind(this)});
    this.setupTabNavigation();
  },

  setupTabNavigation: function() {
    $(this.el).find(".tab:first").show();
    $("#tabs li").removeClass("active");
    $(this.el).find("#tabs a:first").parents("li").addClass("active");
    $(this.el).find(".tab:not(:first)").hide();

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