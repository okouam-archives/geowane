GeoCMS.Helpers.CategoryPicker = Backbone.View.extend({

  events: {
    "change select": "select",
    "click .picked a": "remove"
  },

  initialize: function(options) {
    this.tags = options.location.get("tags");
  },

  remove: function(evt) {
    $(evt.target).parents("li").remove();
  },

  select: function(evt) {
    var value = evt.target.value;
    var text = this.findCategoryFromId(value);
    this.renderCategory(value, text);
    $(evt.target).val("");
  },

  render: function() {
    $("#basic ul.categories").find(".picked").remove();
    if (this.tags.trim() != "") {
      var categories = this.tags.split(",");
      _.each(categories, function(text) {
        var id = this.findIdForCategory(text.trim());
        this.renderCategory(id, text);
      }.bind(this));
    }
  },

  renderCategory: function(id, text){
     $("<li class='picked' data-id='" + id + "'><span>" + text + "</span><a href='#'>x</a></li>").prependTo($("#basic ul.categories"));
  },

  findIdForCategory: function(text) {
    return $("#basic ul.categories").find("select#category option:contains('" + text +"')").val();
  },

  findCategoryFromId: function(id) {
    return $("#basic ul.categories").find("select#category option[value='" + id +"']").text();
  }

});