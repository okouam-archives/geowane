GeoCMS.Helpers.DataTable = Backbone.View.extend({

  events: {
    "click th input[type='checkbox']": "select"
  },

  select: function(evt) {
    var master = $(evt.target);
    var isChecked = master.is(":checked");
    $(this.el).find("td input[type=checkbox]").attr("checked", isChecked);
  },

  uncheckAll: function() {
    $(this.el).find("input[type=checkbox]").attr("checked", false);
  }

});