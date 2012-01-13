GeoCMS.Views.LocationMap = Backbone.View.extend({

  initialize: function(options) {
    this.locations = options.locations;
    this.carto = new Carto();
    this.map = this.carto.map;
    this.carto.addCommonControls();
    this.layer = this.carto.createLayer("Features");
    this.drawing_layer = this.carto.createDrawingLayer();
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
    $(document).bind('listing-updated', this.updateListing.bind(this));
    this.locations.bind("reset", this.render, this);
  },

  updateListing: function(evt, id, name, status, city, longitude, latitude) {
    var updated = _.find(this.layer.features, function(feature) {
      return feature.attributes.id == id;
    });
    updated.move(new OpenLayers.LonLat(longitude, latitude));
  },

  render: function(collection) {
    this.layer.destroyFeatures();
    var features = collection.asFeatures();
    this.carto.displayNumberedFeatures(features, this.layer);
    this.buildInfoTab(features);
  },

  createDrawingTools: function() {
    var canvas = this.drawing_layer;
    var draw = new OpenLayers.Control.DrawFeature(canvas, OpenLayers.Handler.Polygon);

    draw.events.on({
      featureadded: function() {
        draw.deactivate();
        var area = canvas.features[0].geometry;
        this.locations.criteria.set({bbox: area.bounds.toBBOX(), page: 1});
        canvas.destroyFeatures();
      }.bind(this)
    });

    $("#drawing-tool").click(function() {
      if (canvas.features.length < 1) draw.activate();
    });

    $("#eraser-tool").click(function() {
      canvas.destroyFeatures();
      draw.deactivate();
      this.locations.criteria.set({bbox: ""});
    }.bind(this));

    return draw;
  },

  setupControls: function() {
    var draw = this.createDrawingTools();
    var mouseMove = this.createCoordinatesControl();
    this.map.addControls([mouseMove, draw]);
  },

  createCoordinatesControl: function() {
    var mouseMove = new OpenLayers.Control.MousePosition({
      autoActivate: true,
      element: $(".map .coordinates").get(0),
      numDigits: 6
    });
    mouseMove.formatOutput = function(lonLat) {
      return lonLat.lon.toFixed(5) + "E &nbsp; " + lonLat.lat.toFixed(5) + "N";
    };
    return mouseMove;
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