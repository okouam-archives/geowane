GeoCMS.Views.LocationCreator = Backbone.View.extend({

  events: {
    "submit form.new": "createLocation"
  },

  initialize: function() {
    this.mapEditor = new GeoCMS.Views.Lightbox.MapEditor({el: this.el, is_new_location: true});
    $(document).on('click', "#location-creator .actions button", this.save.bind(this));
    $(document).on('input', "#location-creator input", function() {
      $("#location-creator .message").hide();
    }.bind(this));
  },

  save: function() {
    var $inputs = $('#location-creator .tab-contents input');
    var values = {};
    $inputs.each(function() {
      values[this.id] = $(this).val();
    });
    values["longitude"] = this.location.get("longitude");
    values["latitude"] = this.location.get("latitude");
    values["city_id"] = $('#location-creator #city').val();
    $.ajax({
      type: "POST",
      url: "/locations",
      data: {location: values},
      success: function() {
        this.onSuccess($inputs, values["name"]);
      }.bind(this),
      error: this.onFailure.bind(this)
    });
    return false;
  },

  onFailure: function(response) {
    $("#location-creator .message")
            .html(response.statusText)
            .addClass("failure")
            .show();
    return false;
  },

  onSuccess: function($inputs, name) {
    $inputs.each(function() {
      $(this).val("");
    });
    $("#location-creator .message")
            .html("The location has been created. Search for <b>" + name + "</b> to view the location.")
            .addClass("success")
            .show();
    return false;
  },

  createLocation: function() {
    $(document).bind('afterReveal.facebox', function() {
      this.location = new GeoCMS.Models.Location();
      this.location.set({longitude: -4, latitude: 5.3});
      this.location.geography.set({longitude: -4, latitude: 5.3});
      this.mapEditor.associate(this.location);
      this.mapEditor.render();
      $(document).unbind('afterReveal.facebox');
    }.bind(this));
    $.facebox({ajax: "locations/new"});
    return false;
  },

  render: function() {
  }
});