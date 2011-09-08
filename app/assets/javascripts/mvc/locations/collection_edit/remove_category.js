$.Controller("RemoveCategory",
{
  init: function(el, options) {
    this.coordinator = options;
  },

  ".cancel click": function() {
    this.coordinator.reset();
  },

  ".ok click": function() {
    var selected = this.coordinator.getSelectedRows();
    if (selected.length == 0) {
      this.coordinator.showSelectionError();
    } else {
      this.removeCategory(selected);
    }
  },

  removeCategory: function(selected) {
    var locations = selected.map(function() { return $(this).attr("data-id") }).get();
    var category = this.element.find("select").val();
    Categories.remove(locations, category, this.update.bind(this));
  },

  update: function(results) {
    _.each(results, this.redraw.bind(this));
    this.coordinator.reset();
    this.coordinator.uncheckAll();
  },

  redraw: function(tag) {
    var selector = "span.list a[href$='" + tag.tag_id + "']";
    this.coordinator.getRow(tag.location_id).find(selector).parent().remove();
  }
});