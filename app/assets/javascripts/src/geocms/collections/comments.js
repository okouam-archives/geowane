$.Class.extend('Comments',
{
  add: function(locations, comment, callback) {
    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: "/comments/collection_create",
      data: {"comment": comment, "locations": locations},
      success: callback
    });
  }
},
{
  // no instance methods
});