GeoCMS.Views.LocationSearchResults = Backbone.View.extend({

  events: {
    "click tr .name a": "show"
  },

  show: function(evt) {
    var locationInfo = $(evt.target).parents("tr");
    var id = locationInfo.data("id");
    var longitude = locationInfo.data("longitude");
    var latitude = locationInfo.data("latitude");
    this.setupMapEditor(id, longitude, latitude);
    this.showFacebox(id);
    return false;
  },

  showFacebox: function(id) {
    var url = "/locations/" + id  + "/edit?" +  jQuery.param.querystring();
    $.facebox({ajax: url});
  },

  setupMapEditor: function(id, longitude, latitude) {
    if (!window["lightbox-map-editor"]) {
      window["lightbox-map-editor"] = new GeoCMS.Views.LightboxMapEditor();
    }
    var editor = window["lightbox-map-editor"];
    editor.id = id;
    editor.longitude = longitude;
    editor.latitude = latitude;
    $(document).bind('afterReveal.facebox', function() {
      editor.render();
      $(document).unbind('afterReveal.facebox');
    });
  }

});