$.Controller("ChangeStatus",
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
      var category = this.element.find("select").val();
      this.coordinator.getSelectedRows().find(".status select").val(category);
      this.coordinator.reset();
      this.coordinator.uncheckAll();
    }
  }
});