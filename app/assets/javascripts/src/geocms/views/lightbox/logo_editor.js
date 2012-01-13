GeoCMS.Views.Lightbox.LogoEditor = Backbone.View.extend({

  events: {
    "click .delete": "deleteLogo"
  },

  initialize: function(options) {
    this.associate(options.location);
    var uploader = new qq.FileUploader({
      element: document.getElementById('logo-uploader'),
      action: '/locations/' + options.location.id + '/logo',
      onComplete: function(id, fileName, response) {
        if (response.success) {
          this.location.logo.set({url: response.url});
        }
      }.bind(this)
    });
  },

  deleteLogo: function() {
    if (confirm("Are you sure you want to delete this logo?")) {
      $.ajax({
        type: "DELETE",
        url: "/locations/" + this.location.id + "/logo",
        success: function() {
         this.location.logo.set({url: null});
         }.bind(this)
      });
    };
  },

  associate: function(location) {
    if (this.location) this.location.logo.unbind("change", this.render);
    this.location = location;
    this.location.logo.unbind("change", this.render);
    this.location.logo.bind("change", this.render, this);
  },

  render: function() {
    var gallery = $("#logo").find(".gallery");
    gallery.empty();
    if (this.location.logo.get("url") != null) {
      gallery.append("<li style='position: relative; margin-bottom: 10px'><img src='" + this.location.logo.get("url") + "' /><a class='delete' data-id='" + this.location.logo.get("id") + "' style='position: absolute; height: 25px; width: 24px; left: 0; top: 0; background: url(https://ssl.gstatic.com/ui/v1/icons/mail/sprite_black2.png) no-repeat -61px -41px #ccc' href='#'></a></li>");
    }
  }

});

