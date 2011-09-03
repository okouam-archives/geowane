$.Controller("ManageMap",
{
  init: function() {
    this.map = Carto.build();
    Carto.addCommonControls(this.map);
    this.layer = Carto.createDrawingLayer("Features", this.map);
    this.setupControls();
    this.map.zoomTo(0);
    $("input[type='submit']").click(this.buildBoundingBox.bind(this));
  },

  buildBoundingBox: function() {
    if (this.layer.features.length > 0) {
      var searchBox = this.layer.features[0].geometry.bounds.toBBOX();
      $("#search_criteria_bbox").val(searchBox);
    }
    return true;
  },

  setupControls: function() {
    var draw = new OpenLayers.Control.DrawFeature(this.layer, OpenLayers.Handler.Polygon);
    var self = this;
    this.map.addControls([draw]);
    $("#draw").click(function() {
      if ($(this).attr("checked")) {
        draw.activate();
      }
      else {
        self.layer.destroyFeatures();
        draw.deactivate();
      }
    });
  }
});