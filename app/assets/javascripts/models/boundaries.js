$.Class.extend('Boundaries',
{
  fetch: function(level, callback) {
    $.ajax({
      url: "/boundaries/" + level,
      type: "GET",
      dataType: "json",
      success:  function(data) {
        var boundaries = $(data).map(function() {
          return this.boundary;
        });
        callback(boundaries.get());
      }
    });
  }
},
{ /* no instance methods */ });