$.Controller("AddCategory",
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
      this.addCategory(selected)
    }
  },

  addCategory: function(selected) {
    var locations = selected.map(function() { return $(this).attr("data-id") }).get();
    var category = this.element.find("select").val();
    Categories.add(locations, category, this.update.bind(this));
  },

  update: function(results) {
    _.each(results, this.redraw.bind(this));
   this.coordinator.reset();
   this.coordinator.uncheckAll();
  },

  redraw: function(tag) {
    var html = $(JST['templates/tag_template'](tag));
    var id = tag.location_id;
    var wrapper = this.coordinator.getRow(id).find(".tags .list");
    html.appendTo(wrapper);
  }
});