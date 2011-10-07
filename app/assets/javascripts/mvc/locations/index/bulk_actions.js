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

  hasSelection: function() {
    var outcome = true;
    if ($("td.selector input:checked").length < 1) {
      alert("Please select one or more locations");
      outcome = false;
    }
    return outcome;
  },

  "input[type='button'] click": function() {
    if(!this.hasSelection()) return false;
    var selected = this.element.find("select").val();
    switch(selected) {
      case "Edit":
        var locations = this.collect();
        var querystring = jQuery.param.querystring() + "&locations=" + locations.toArray().join(",");
        window.location = "/locations/edit?" + querystring;
        return true;
      case "Delete":
        return this.collection_change('locations', 'delete');
      case "Export":
        $("form").attr("action", "/exports/prepare");
        $("form").submit();
        return false;
    }
  },

  collect: function() {
    return  $("td.selector input:checked").map(function(i, el) {
      return $(el).val();
    });
  }

});
