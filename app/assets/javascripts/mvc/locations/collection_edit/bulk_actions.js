$.Controller("BulkActions",
{
  init: function() {
    $(".action-portlet").hide();
    this.remove_category_portlet = $(".action-portlet.remove_category");
    this.remove_category_portlet.remove_category(this);
    this.add_category_portlet = $(".action-portlet.add_category");
    this.add_category_portlet.add_category(this);
    this.add_comment_portlet = $(".action-portlet.add_comment");
    this.add_comment_portlet.add_comment(this);
    this.change_status_portlet = $(".action-portlet.change_status");
    this.change_status_portlet.change_status(this);
    this.change_city_portlet = $(".action-portlet.change_city");
    this.change_city_portlet.change_city(this);
  },

  "select change": function(called) {
    var portlet_id  =  $(called).val();
    this.hideActionPortlets();
    if (portlet_id == "Bulk Actions") return;
    var portlet;
    switch(portlet_id) {
      case "Remove Category":
        portlet = this.remove_category_portlet;
        break;
      case "Add Category":
        portlet = this.add_category_portlet;
        break;
      case "Add Comment":
        portlet = this.add_comment_portlet;
        break;
      case "Change Status":
        portlet = this.change_status_portlet;
        break;
      case "Change City":
        portlet = this.change_city_portlet;
        break;
    }
    if (portlet) portlet.show();
  },

  getSelectedRows: function() {
    return $("tr").has(".selector input:checked");
  },

  reset: function() {
    this.hideActionPortlets();
    this.element.find("select").val("Bulk Actions");
  },

  hideActionPortlets: function() {
    $(".action-portlet").hide();
    this.element.show();
  },

  showSelectionError: function() {
    alert("Please select one or more locations.");
  },

  uncheckAll: function() {
    $("input[type='checkbox']").attr("checked", false);
  },

  select: function(id) {
    var row = $("tr[data-id=" + id + "]");
    row.find(".selector input").attr("checked", true);
  },

  getRow: function(id) {
    return $("tr[data-id=" + id + "]");
  }
});