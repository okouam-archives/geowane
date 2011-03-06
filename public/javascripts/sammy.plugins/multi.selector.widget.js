(function($) {

  Sammy = Sammy || {};

  Sammy.MultiSelectorWidget = function(app, tableSelector) {

    var table = $(tableSelector);
    var items = table.find("td input[type='checkbox']");
    var master = table.find("th input[type='checkbox']");

    master.click(function() {
      var isChecked = $(this).attr("checked");
      items.attr("checked", isChecked);
    });

    this.helpers({

      getSelected: function() {
        return table.find("td.selector input:checked").map(function(i, e) {
          return $(e).parents("tr").attr("data-id");
        });
      },

      showSelectionError: function() {
        alert("Please select one or more locations.");
        return this.redirect('#');
      }

    });

  };

})(jQuery);