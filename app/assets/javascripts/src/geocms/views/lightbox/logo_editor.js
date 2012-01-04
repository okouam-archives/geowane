GeoCMS.Views.Lightbox.LogoEditor = Backbone.View.extend({

  initialize: function(options) {
    var uploader = new qq.FileUploader({
      element: document.getElementById('logo-uploader'),
      action: '/locations/' + options.location.id + '/logo',
      onComplete: function(id, fileName, response) {
        if (response.success) {
          this.location.logo = new Logo(response.logo);
        }
      }.bind(this)
    });
  },

  associate: function(location) {
    if (this.location) this.location.logo.unbind("change", this.render);
    this.location = location;
    this.location.logo.unbind("change", this.render);
    this.location.logo.bind("change", this.render, this);
  },

  render: function() {
    console.debug(this.location.logo);
  }

});

