//= require_tree .

$(function() {
  $("table.main").add_category_inline();
  $("table.main").checkboxes();
  $(".bulk-actions").bulk_actions();
});
