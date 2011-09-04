$.Controller("BoundaryPicker",
{
  init: function() {
    this.current_level = "level_0";
    this.boundary = this.element.find(":hidden");
  },

  "select change": function(el) {
    var level = $(el).val();
    this.boundary.val(level);
    this.current_level = $(el).attr("name");
    Boundaries.fetch(level, this.update.bind(this));
  },

  update: function(boundaries) {
    if (boundaries.length > 0) {
      this.createBoundaryPicker(1, boundaries);
    }
  },

  createBoundaryPicker: function(level, boundaries) {
    var template = "<div><label></label><select></select></div>"
  }
});