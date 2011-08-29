$.Controller("Checkboxes",
{
  init: function(el) {
    $(el).find("th input[type=checkbox]").click(function() {
      var master = $(this);
      var isChecked = master.is(":checked");
      $("td input[type=checkbox]").attr("checked", isChecked);
    });
  }
});