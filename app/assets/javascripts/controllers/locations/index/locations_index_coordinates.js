$.Controller("LocationsIndexCoordinates",
{
  "geocms.locations-retrieved subscribe": function(called, params) {
    var table = this.element.find("tbody");
    table.empty();
    for(var i = 0; i < params.length; i++){
      var location = params[i];
      $("<tr><td>" + location.attributes.counter + "</td><td>" + location.attributes.name + "</td></tr>").appendTo(table);
    }
    table.find('tr:odd').css('background-color', '#fbfbfb');
  }
});