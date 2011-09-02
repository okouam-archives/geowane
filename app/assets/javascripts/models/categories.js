$.Class.extend('Categories',
{
  add: function(locations, category, callback) {
    this.action(locations, category, callback, "add_tag");
  },
  remove: function(locations, category, callback) {
    this.action(locations, category, callback, "remove_tag");
  },
  action: function(locations, category, callback, call) {
    $.ajax({
      url: "/locations",
      type: "PUT",
      data: {locations: locations, call: call, category: category},
      success: callback
    });
  }
},
{ /* no instance methods */ });