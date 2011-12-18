GeoCMS.Views.LocationSearchResults = Backbone.View.extend({

  events: {
    "click tr .name a": "show"
  },

  show: function(evt) {
    var id = $(evt.target).parents("tr").data("id");
    this.setupEditor(id);
    this.showFacebox(id);
    return false;
  },

  showFacebox: function(id) {
    var url = "/locations/" + id  + "/edit?" +  jQuery.param.querystring();
    $.facebox({ajax: url});
  },

  setupEditor: function(id) {
    if (!window["location-editor"]) {
      window["location-editor"] = new GeoCMS.Views.LocationEditor();
    }
    var editor = window["location-editor"];
    editor.id = id;
    $(document).bind('afterReveal.facebox', function() {
      editor.render();
      $(document).unbind('afterReveal.facebox');
    });
  }

});