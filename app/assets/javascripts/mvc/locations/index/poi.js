$.Controller("Poi",
{
  init: function(el) {
  },

  "tr .name a click": function(el) {
    return this.showLocation($(el).parents("tr").data("id"));
  },

  showLocation: function(id) {
    var url = "/locations/" + id  + "/edit?" +  jQuery.param.querystring();
    $.facebox({ajax: url});
    return false;
  }
});
