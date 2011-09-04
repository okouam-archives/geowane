$.Controller("BoundaryPicker",
{
  init: function() {
    this.boundary = this.element.find(":hidden");
  },

  "select change": function(el) {
    var new_boundary_id = $(el).val();
    this.boundary.val(new_boundary_id);
    this.current_level = $(el).attr("name").charAt(6);
    if (new_boundary_id) {
      Boundaries.fetch(new_boundary_id, this.update.bind(this));
    } else {
      this.update();
    }
  },

  update: function(boundaries) {
    var current_level = this.current_level;
    var dropdowns = this.element.find("select");
    var not_required = $.grep(dropdowns.toArray(), function(n) {
      var level = $(n).attr("name").charAt(6);
      return level > current_level;
    });
    $(not_required).parent().remove();
    if (boundaries && boundaries.length > 0) {
      this.createBoundaryPicker(parseInt(current_level) + 1, boundaries);
    }
  },

  createBoundaryPicker: function(level, boundaries) {
    this.current_level = level;
    var listTemplate = $.template("boundary", "<div class='boundary'><label>" + boundaries[0].classification + "</label><select id='level_" + level+ "' name='level_" + level + "'><option></option>{{tmpl($data.results) \"nested\"}}</select></div>");
    $.template("nested", "<option value='${id}'>${name}</option>");
    this.element.find("select").last().parent().after($.tmpl(listTemplate, {results: boundaries}));
  }
});