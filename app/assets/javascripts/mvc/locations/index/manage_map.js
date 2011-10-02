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
      },
      outFeature: function() {
        Carto.hideTipsy();
      }
    });
    this.map.addControls([tooltip]);
    tooltip.activate();
  },

  buildInfoTab: function(features, footer) {
    var contents = footer.find(".contents");
    var wrapper = contents.children("ul").empty();
    var template = $.template(null,
      "<li> \
        <span style='font-weight: bold'>${attributes.counter}. </span> \
        <span class='name'>${attributes.name}</span> \
      </li>"
    );
    var output = $($.tmpl(template, features));
    wrapper.append(output);
    footer.find(".tab").click(function() {
      if ($(this).text() == "show") $(this).text("hide");
      else $(this).text("show");
      contents.toggle();
      return false;
    });
  }
});