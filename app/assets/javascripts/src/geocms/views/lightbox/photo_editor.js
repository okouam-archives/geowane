GeoCMS.Views.Lightbox.PhotoEditor = Backbone.View.extend({

  events: {
    "click .delete": "deletePhoto"
  },

  initialize: function(options) {
    this.associate(options.location);
    var uploader = new qq.FileUploader({
      element: document.getElementById('photo-uploader'),
      action: '/locations/' + options.location.id + '/photos',
      onComplete: function(id, fileName, response) {
        if (response.success) {
          this.location.photos.add(new GeoCMS.Models.Photo({url: response.url, id: response.id}));
        }
      }.bind(this)
    });
  },

  deletePhoto: function(evt) {
    var anchor = $(evt.currentTarget);
    var id = anchor.data("id");
    if (confirm("Are you sure you want to delete this photo?")) {
      $.ajax({
        type: "DELETE",
        url: "/locations/" + this.location.id + "/photos/" + id,
        success: function() {
          this.location.photos.remove(this.location.photos.get(id));
        }.bind(this)
      });
    };
  },

  associate: function(location) {
    if (this.location) this.location.photos.unbind("reset");
    this.location = location;
    this.location.photos.unbind("reset");
    this.location.photos.bind("reset", this.render, this);
    this.location.photos.bind("add", this.render, this);
    this.location.photos.bind("remove", this.render, this);
  },

  render: function() {
    var gallery = $("#photos").find(".gallery");
    gallery.empty();
    var html = _.map(this.location.photos.models, function(item) {
      return "<li style='position: relative; margin-bottom: 10px'><img src='" + item.get("url") + "' /><a class='delete' data-id='" + item.get("id") + "' style='position: absolute; height: 25px; width: 24px; left: 0; top: 0; background: url(https://ssl.gstatic.com/ui/v1/icons/mail/sprite_black2.png) no-repeat -61px -41px #ccc' href='#'></a></li>";
    });
    gallery.append(html.join(""));
  }

});

