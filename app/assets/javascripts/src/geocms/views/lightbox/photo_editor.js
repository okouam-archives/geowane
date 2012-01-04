GeoCMS.Views.Lightbox.PhotoEditor = Backbone.View.extend({

  initialize: function(options) {
    $(function() {
      var uploader = new qq.FileUploader({
        element: document.getElementById('photo-uploader'),
        action: '/api/locations/' + options.location.id + '/photos'
      });
    });
  },

  associate: function(location) {
    if (this.location) this.location.photos.unbind("reset");
    this.location = location;
    this.location.photos.unbind("reset");
    this.location.photos.bind("reset", this.render, this);
  }

});

