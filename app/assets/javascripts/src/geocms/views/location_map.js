GeoCMS.Views.LocationMap = Backbone.View.extend({

  initialize: function(options) {
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
    $("#map-glossary").click(function() {
      if ($(this).text() == "Show Location Glossary +") $(this).text("Hide Location Glossary -");
      else $(this).text("Show Location Glossary +");
      $("#map-key").toggle();
      return false;
    });
    options.locations.bind("reset", this.render, this);
  },

  render: function(collection) {
    this.layer.destroyFeatures();
    var features = collection.asFeatures();
    this.carto.displayNumberedFeatures(features, this.layer);
    this.buildInfoTab(features);
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

  buildInfoTab: function(features) {
    var wrapper = $("#map-key ul").empty();
    var template = $.template(null,
      "<li> \
        <span>${attributes.counter}. </span> \
        <span class='name'>${attributes.name}</span> \
      </li>"
    );
    var output = $($.tmpl(template, features));
    wrapper.html(output);
  }
});