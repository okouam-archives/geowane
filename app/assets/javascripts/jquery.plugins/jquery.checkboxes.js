(function($) {
  $.fn.checkboxes = function() {
    $.fn.checkboxes.self = $(this);
    $.fn.checkboxes.self.find("th input[type=checkbox]").click(function() {
      var master = $(this);
      var isChecked = master.is(":checked");
      $.fn.checkboxes.self.find("td input[type=checkbox]").attr("checked", isChecked);
    });
  };
  $.fn.checkboxes.uncheckAll = function() {
    $.fn.checkboxes.self.find("input[type=checkbox]").attr("checked", false);
  };
})(jQuery);