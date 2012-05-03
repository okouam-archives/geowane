GeoCMS.Views.Categories.SearchResults = Backbone.View.extend({

  events: {
    "click tr .name a": "show"
  },

  initialize: function() {
    $(document).bind('listing-updated', this.updateListing.bind(this));
    $(".toolbar .delete").click(this.deleteCategories.bind(this));
  },

  deleteCategories: function() {
    if (confirm("Are you sure you want to delete these categories?")) {
      $checkboxes = $("table.main td :checkbox").filter(":checked");
      var categories = [];
      $checkboxes.each(function(i, item) {
        categories.push($(item).val());
      });
      $.ajax({
        type: "DELETE",
        url: "/categories/collection",
        data: {categories: categories},
        success: function() {
          window.location = "/categories"
        }
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

  show: function(evt) {
    this.showEditor($(evt.target).data("id"));
    return false;
  },

  showEditor: function(category_id) {
    $(document).bind('afterReveal.facebox', function() {
      window.App.Lightbox = new GeoCMS.Views.Categories.Lightbox.Editor({el: "#facebox", id: category_id});
      $(document).unbind('afterReveal.facebox');
    });
    $.facebox({ajax: "/categories/" + category_id + "/edit"});
  }

});