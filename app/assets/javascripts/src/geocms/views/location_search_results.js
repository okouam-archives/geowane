GeoCMS.Views.LocationSearchResults = Backbone.View.extend({

  LOCATION_ROW_TEMPLATE:
  "<% for (var i = 0; i < models.length; i++) { %> \
   <tr> \
    <td class='selector'> \
      <input type='checkbox' name='locations[]' value='<%= models[i].attributes.id %>' /> \
    </td> \
    <td class='name'> \
      <% if (models[i].attributes.name.length > 40) { %> \
        <img src='assets/warning-icon.png') /> \
      <% } %> \
      <a data-id='<%= models[i].attributes.id %>' href='#'><%= models[i].attributes.name %></a> \
    <td><%= models[i].attributes.city %> </td> \
    <td><%= models[i].attributes.tags %> </td> \
    <td><%= models[i].attributes.added_by %> </td> \
    <td><%= models[i].attributes.created_at %></td> \
    <td><%= models[i].attributes.updated_at %></td> \
    <td><%= models[i].attributes.status %></td> \
  </tr> \
   <% } %>",

  events: {
    "click tr .name a": "show"
  },

  initialize: function(options) {
    this.locations = collection = options.locations;
    collection.bind("reset", this.render, this);
    $.App.Search.bind("change", function() {
      collection.criteria = $.App.Search;
      collection.fetch();
    }, this);
    new GeoCMS.Views.LocationPager({el: $(this.el).find("#pagination-wrapper")});
    new GeoCMS.Helpers.DataTable({el: this.el});
    new GeoCMS.Helpers.SortableTable({el: this.el, callback: function(val) {
        $.App.Search.set({sort: val});
      }
    });
    this.map = new GeoCMS.Views.LocationMap({el: $("manage_map"), locations: collection});
    collection.trigger("reset", collection);
  },

  render: function() {
    $(this.el).find("tbody").html(_.template(this.LOCATION_ROW_TEMPLATE, this.locations));
  },

  show: function(evt) {
    var element = $(evt.target);
    var location = this.locations.get(element.data("id"));
    this.showEditor(location);
    return false;
  },

  showEditor: function(location) {
    var collection = this.locations;
    $(document).bind('afterReveal.facebox', function() {
      if (!window.App.Lightbox) {
        window.App.Lightbox = new GeoCMS.Views.Lightbox.Editor({el: "#facebox", current: location, collection: collection});
      } else {
        window.App.Lightbox.associate(location, collection);
      }
      location.change();
      $(document).unbind('afterReveal.facebox');
    });
    $.facebox({ajax: location.url() + "/edit"});
  }

});