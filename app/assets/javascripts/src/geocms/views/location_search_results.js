GeoCMS.Views.LocationSearchResults = Backbone.View.extend({

  LOCATION_ROW_TEMPLATE:
  "<% for (var i = 0; i < models.length; i++) { %> \
   <tr data-id='<%= models[i].attributes.id %>'> \
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
    collection.criteria.bind("change", function() {
      collection.fetch();
    }, this);
    new GeoCMS.Views.LocationPager({el: $("#pagination-wrapper"), locations: collection});
    new GeoCMS.Helpers.DataTable({el: this.el});
    new GeoCMS.Helpers.SortableTable({el: this.el, callback: function(val) {
        collection.criteria.set({sort: val, page: 1});
      }
    });
    this.map = new GeoCMS.Views.LocationMap({el: $("manage_map"), locations: collection});
    collection.trigger("reset", collection);
    $(document).bind('listing-updated', this.updateListing.bind(this));
    $(".toolbar .delete").click(this.deleteLocations.bind(this));
    $(".toolbar .collection-edit").click(this.editLocations.bind(this));
  },

  deleteLocations: function() {
    if (confirm("Are you sure you want to delete these locations?")) {
      $checkboxes = $("table.main td :checkbox").filter(":checked");
      var locations = [];
      $checkboxes.each(function(i, item) {
        locations.push($(item).val());
      });
      $.ajax({
        type: "DELETE",
        url: "/locations/collection",
        data: {locations: locations},
        success: function() {
          this.locations.criteria.set({page: 1});
          this.locations.criteria.change();
        }.bind(this)
      });
    }
  },

  updateListing: function(evt, id, name, status, city, longitude, lagitude, tags) {
    $row = $("table.main tr[data-id='" + id + "']");
    if ($row) {
      $cells = $row.find("td");
      $cells.eq(1).find("a").text(name);
      $cells.eq(2).text(city);
      $cells.eq(3).text(tags);
      $cells.eq(7).text(status);
    }
  },

  editLocations: function() {

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
      window.App.Lightbox = new GeoCMS.Views.Lightbox.Editor({el: "#facebox", current: location, collection: collection});
      location.change();
      $(document).unbind('afterReveal.facebox');
    });
    $.facebox({ajax: location.url() + "/edit"});
  }

});