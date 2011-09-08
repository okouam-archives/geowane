$.Controller("ChangeCity",
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
      var city = this.element.find("select").val();
      this.coordinator.getSelectedRows().find(".city select").val(city);
      this.coordinator.reset();
      this.coordinator.uncheckAll();
    }
  }
});