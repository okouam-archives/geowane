$.Controller("ManageMap",
{
  init: function(el, features) {
    this.map = Carto.build();
    Carto.addCommonControls(this.map);
    this.layer = Carto.createLayer("Features", this.map);
    this.setupControls();
    Carto.displayNumberedFeatures(features, this.layer);
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
  }
});