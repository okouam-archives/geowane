$.Class.extend('Boundaries',
{
  fetch: function(level, callback) {
    $.ajax({
      url: "/boundaries/" + level,
      type: "GET",
      dataType: "json",
      success:  callback
    });
  }
},
{ /* no instance methods */ });