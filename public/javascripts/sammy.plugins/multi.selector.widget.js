(function($) {

  Sammy = Sammy || {};

  Sammy.MultiSelectorWidget = function(app, table) {

    app.selected_locations = app.selected_locations || [];

    var items = table.find("td input[type='checkbox']");
    var master = table.find("th input[type='checkbox']");

    master.click(function() {
      var isChecked = $(this).attr("checked");
      items.attr("checked", isChecked);
      app.selected_locations = isChecked ? Location.pluck("id") : [];
    });

    items.click(function() {
      var id = $(this).parents("tr").attr("data-id");
      if( $(this).is(':checked') ){
        app.selected_locations.push(id);
      } else {
        app.selected_locations = _.reject(app.selected_locations, function(loc) {
          return loc == id;
        });
      }
    });

    this.helpers({

      showSelectionError: function() {
        alert("Please select one or more locations.");
        return this.redirect('#/');
      },

      uncheckAll: function() {
        master.attr("checked", false);
        items.attr("checked", false);
        app.selected_locations = [];
      },

      select: function(id) {
        var row = $("tr[data-id=" + id + "]");
        row.find(".selector input").attr("checked", true);
        app.selected_locations = [id];
      },

      getRow: function(id) {
        return $("tr[data-id=" + id + "]");
      }

    });

  };

})(jQuery);