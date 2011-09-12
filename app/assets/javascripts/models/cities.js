$.Class.extend('Cities',
{
  remove: function(cities, callback) {
    $.ajax({
      url: "/cities/collection_delete",
      type: "POST",
      data: {collection: cities},
      success: callback
    });
  }
},
{ /* no instance methods */ });