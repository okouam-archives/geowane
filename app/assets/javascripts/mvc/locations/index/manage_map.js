$.Controller("ManageMap",
{
  init: function(el, options) {
    this.carto = new Carto();
    this.map = this.carto.map;
    this.carto.addCommonControls();
    this.layer = this.carto.createLayer("Features");
    new GeoCMS.Maps.Coordinates(this.map);
    new GeoCMS.Maps.Search(this.map);
    new GeoCMS.Maps.Signposting(this.layer, function(feature) {
      window.location = "/locations/" + feature.attributes["id"] + "/edit";
    });
    this.setupControls();
    this.carto.displayNumberedFeatures(options.features, this.layer);
    this.buildInfoTab(options.features, options.footer);
  },

  setupControls: function() {
    var mouseMove = new OpenLayers.Control.MousePosition({
      autoActivate: true,
      element: $(".map .coordinates").get(0),
      numDigits: 6
    });
    mouseMove.formatOutput = function(lonLat) {
      return lonLat.lon.toFixed(5) + "E &nbsp; " + lonLat.lat.toFixed(5) + "N";
    };
    this.map.addControls([mouseMove]);
  },

  buildInfoTab: function(features, footer) {
    var wrapper = $("#map-key ul").empty();
    var template = $.template(null,
      "<li> \
        <span>${attributes.counter}. </span> \
        <span class='name'>${attributes.name}</span> \
      </li>"
    );
        var output = $($.tmpl(template, features));
    wrapper.append(output);
    $("#map-glossary").click(function() {
      if ($(this).text() == "Show Location Glossary +") $(this).text("Hide Location Glossary -");
      else $(this).text("Show Location Glossary +");
      $("#map-key").toggle();
      return false;
    });
  }
});