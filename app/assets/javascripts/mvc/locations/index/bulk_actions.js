$.Controller("BulkActions",
{
  collection_change: function(url, method) {
    if ($("td.selector input:checked").length < 1) {
      alert("Please select one or more locations");
      return false;
    }
    $("form").attr("action", url);
    if (method)   $('<input type="hidden" name="_method" value="' + method + '" />').appendTo($("form"));
    $("form").submit();
    return false;
  },

  init: function(el) {
    var self = this;
    $(el).find("input[type='button']").click(function() {
      var selected = $(el).find("select").val();
      switch(selected) {
        case "Edit":
          return self.collection_change('locations/edit');
        case "Delete":
          return self.collection_change('locations', 'delete');
        case "Export":
          $("form").attr("action", "/exports/prepare");
          $("form").submit();
          return false;
      }
    });
  }
});
