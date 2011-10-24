$.Controller("EditInformation",
{
  init : function(el, options){
    this.location_id = options.location_id;
  },
  "select change": function(el) {
    var item = $(el).val();
    $("#" + item).show();
    $(el).val("Add field");
  }
});