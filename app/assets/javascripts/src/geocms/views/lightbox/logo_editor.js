GeoCMS.Views.Lightbox.LogoEditor = Backbone.View.extend({

  initialize: function(options) {

    $(function() {
      var uploader = new qq.FileUploader({
        element: document.getElementById('file-uploader'),
        action: '/api/locations/' + options.location.id + '/logo'
      });
    });
  },

  associate: function(location) {
    if (this.location) this.location.logo.unbind("change", this.render);
    this.location = location;
    this.location.logo.unbind("change", this.render);
    this.location.logo.bind("change", this.render, this);
  },

  render: function() {
    this.location
  }

});

