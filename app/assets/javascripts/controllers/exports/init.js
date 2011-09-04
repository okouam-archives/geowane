//= require_tree .

$(function() {
  $(".portlet.categories").partner_picker();
  $(".portlet.categories table.main").checkboxes();
  $(".portlet.users table.main").checkboxes();
  $(".portlet.countries table.main").checkboxes();
  $(".portlet.workflow table.main").checkboxes();

  $("input[type='checkbox']").change(function() {
    var data = $("form").formParams();
    $.post("/exports/count", data, function(result) {
      $(".location-count").html(result);
    });
  });

  $("input[type='checkbox']").click(function() {
    $(this).trigger("change");
  });

});
