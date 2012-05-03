GeoCMS.Views.Lightbox.Editor = Backbone.View.extend({

  TAG_EMPLATE:
    "<ul> \
      <% foreach(var tag in tags) { %> \
        <li data-tag='tag.id'> \
          <%= tag.name %> \
          <a href='#'>x</a>\
        </li> \
      <% } %> \
    </ul>",

  events: {
    "click .previous": "previous",
    "click .next": "next",
    "click #geography .actions button": "save"
  },

  initialize: function(options) {
    if (!options.current) throw new Exception("No current location was passed to the Lightbox Editor");
    if (!options.collection) throw new Exception("No current location was passed to the Lightbox Editor");
    this.commentEditor= new GeoCMS.Views.Lightbox.CommentEditor({el: "#comments.tab", location: options.current});
    this.mapEditor = new GeoCMS.Views.Lightbox.MapEditor({el: "#geography.tab", location: options.current});
    this.mapEditor.bind('location-moved', function(coordinates) {
      this.coordinates = coordinates
    }.bind(this));
    this.categoryPicker = new GeoCMS.Helpers.CategoryPicker({el: "#basic ul.categories", location: options.current});
    this.infoEditor = new GeoCMS.Views.Lightbox.InfoEditor({el: "#info.tab", location: options.current});
    this.photoEditor = new GeoCMS.Views.Lightbox.PhotoEditor({el: "#photos.tab", location: options.current});
    this.logoEditor = new GeoCMS.Views.Lightbox.LogoEditor({el: "#logo.tab", location: options.current});
    this.associate(options.current, options.collection);
  },

  associate: function(current, collection) {
    if (this.current) this.current.unbind("change");
    this.current = current;
    if (collection) this.locations = collection;
    this.mapEditor.associate(current);
    this.commentEditor.associate(current);
    this.infoEditor.associate(current);
    this.logoEditor.associate(current);
    this.photoEditor.associate(current);
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

  save: function() {
    var name = $(this.el).find("#basic #name").val();
    var status = $(this.el).find("#basic #status").val();
    var status_display = $(this.el).find("#basic #status option:selected").text();
    var city = $(this.el).find("#basic #city").val();
    var city_display = $(this.el).find("#basic #city option:selected").text();
    var categories = _.map($(this.el).find(".picked"), function(el) {
      return $(el).data("id");
    });
    var category_displays = _.map($(this.el).find(".picked span"), function(el) {
      return $(el).text();
    }).join(", ");
    if (this.coordinates) {
      var longitude = this.coordinates.longitude;
      var latitude =  this.coordinates.latitude;
    } else {
      var longitude = this.current.get("longitude");
      var latitude = this.current.get("latitude");
    }

    $("#" + this.el.id).find(".warning").hide();
    $.ajax({
      type: "PUT",
      url: "/locations/" + this.current.id,
      data: {
        location: {
          name: name,
          tags: categories,
          status: status,
          city_id: city,
          longitude: longitude,
          latitude: latitude
        }
      },
      success: function() {
        $(document).trigger("listing-updated", [this.current.id, name, status_display, city_display, longitude, latitude, category_displays]);
        this.current.fetch();
      }.bind(this)
    });
  },

  showWarning: function() {
    $("#geography .warning").html("The location has been modified. Click 'Accept' to keep changes.").show();
  },

  render: function() {

    var wrapper = $("#" + this.el.id);

    wrapper.find(".warning").hide();

    wrapper.find("span.location_name").text(this.current.get("name"));

    var name_input = wrapper.find("#basic #name");
    name_input.val(this.current.get("name"));

    var city_selector = wrapper.find("#basic #city");
    var city_id = city_selector.find("option:contains('" + this.current.get("city") + "')").val();
    city_selector.val(city_id);

    var status_selector = wrapper.find("#basic #status");
    var status_id = status_selector.find("option:contains('" + this.current.get("status") + "')").val();
    status_selector.val(status_id);

    wrapper.find("input").bind('input', function() {
      this.showWarning();
    }.bind(this));

    wrapper.find("select").change(function() {
      this.showWarning();
    }.bind(this));

    this.categoryPicker.tags = this.current.get("tags");
    this.categoryPicker.render();

    this.current.comments.fetch();
    this.current.info.fetch();
    this.current.logo.fetch({success: function() {
      this.current.logo.change();
    }.bind(this)});
    this.current.photos.fetch();
    this.current.geography.fetch({success: function() {
      this.current.geography.change();
    }.bind(this)});
    this.setupTabNavigation(wrapper);
  },

  setupTabNavigation: function(wrapper) {
    wrapper.find(".tab:first").show();
    $("#tabs li").removeClass("active");
    wrapper.find("#tabs a:first").parents("li").addClass("active");
    wrapper.find(".tab:not(:first)").hide();

    wrapper.find("#tabs a").click(function() {
      var ref = $(this).attr("href").split('#')[1];
      $("#tabs li").removeClass("active");
      $(this).parents("li").addClass("active");
      $(".tab:not(#" + ref + ")").hide();
      $("#" + ref).show();
      return false;
    })
  }
});