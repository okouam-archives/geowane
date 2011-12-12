$.Controller("Poi",
{
  init: function(el) {
  },

  "tr .name a click": function(el) {
    this.showLocation($(el).parents("tr").data("id"));
  },

  showLocation: function(id) {
    //$.facebox({ajax: "/locations/" + id  + "/edit"});
    //return false;
  }
});
