$.Controller("NamePicker",
{
  "input[type='text'] keyup": function(el) {
    var table = this.element.find("table");
    var query = $(el).val();
    if (query.length > 2) {
      $.getJSON('/search/lookup?limit=20&q=' + query, function(data) {
        var template = "<tr><td><a href='/locations/${id}/edit'>${name}</a></td><td>${city}</td><td style='width: 80px'>${country}</td></tr>";
        var html = $.tmpl(template, data);
        table.empty();
        table.append("<tr><th>Name</th><th>City</th><th>Country</th></tr>");
        table.append(html);
        if (data.length > 19) {
          table.append("<tr><td colspan='3'>More than 20 places were found. Only 20 have been shown.</td></tr>");
        }
        table.show();
        table.find('tr:odd').css('background-color', '#fbfbfb');
      });
    }
    else if (query.length == 0) {
      table.hide();
    } else {
      table.html("<tr><td>Try entering at least 3 chars to find POIs directly.</td></tr>");
      table.show();
    }
    table.find('tr:odd').css('background-color', '#fbfbfb');
  }
});