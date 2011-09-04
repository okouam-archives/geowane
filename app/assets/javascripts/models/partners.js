$.Class.extend('Partners',
{
  remove: function(partners, callback) {
    $.ajax({
      url: "/partners/collection_delete",
      type: "POST",
      data: {collection: partners},
      success: callback
    });
  }
},
{ /* no instance methods */ });