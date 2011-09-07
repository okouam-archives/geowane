$.Class.extend('Exports',
{
  fetch: function(users, categories, countries, statuses, callback) {
    $.ajax({
      type: 'GET',
      dataType: 'json',
      url: "/exports/count",
      data: {"users": users, "categories": categories, countries: countries, statuses: statuses},
      success: callback
    });
  }
},
{
  // no instance methods
});