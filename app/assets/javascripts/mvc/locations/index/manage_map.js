$.Controller("ManageMap",
{
  init: function(el, options) {
    this.map = Carto.build();
    Carto.addCommonControls(this.map);
    this.layer = Carto.createLayer("Features", this.map);
    this.setupControls();
    Carto.displayNumberedFeatures(options.features, this.layer);
    this.buildInfoTab(options.features, options.footer);
  },

  setupControls: function() {
    var tooltip = new OpenLayers.Control.SelectFeature(this.layer, {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function(feature) {
        Carto.showLabel(feature);
        $("body").css("cursor", "pointer");
        $("body").on('click.map', function() {
          window.location = "/locations/" + feature.attributes["id"] + "/edit";
        })
      },
      outFeature: function() {
        Carto.hideTipsy();
        $("body").css("cursor", "auto");
        $("body").off('click.map');
      }
    });
    var mouseMove = new OpenLayers.Control.MousePosition({
      autoActivate: true,
      element: $(".map .coordinates").get(0),
      numDigits: 6
    });
    mouseMove.formatOutput = function(lonLat) {
      return lonLat.lon.toFixed(5) + "W &nbsp; " + lonLat.lat.toFixed(5) + "N";
    };
    this.map.addControls([tooltip, mouseMove]);
    tooltip.activate();
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