$.Controller("Checkboxes",
{
  init: function(el) {
    this.table = $(el);
    var self = this;
    this.table.find("th input[type=checkbox]").click(function() {
      var master = $(this);
      var isChecked = master.is(":checked");
      self.find("td input[type=checkbox]").attr("checked", isChecked);
    });
  },

  uncheckAll: function() {
    this.find("input[type=checkbox]").attr("checked", false);
  }
});