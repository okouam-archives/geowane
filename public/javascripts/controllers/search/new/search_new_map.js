$.Controller("SearchNew",
{
  init: function(el, options) {
    OpenLayers.ImgPath = "/images/OpenLayers/";
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
    this.map = new OpenLayers.Map("mappanel", {
        theme: null,
        maxResolution: 0.02197265625,
        numZoomLevels: 14,
        restrictedExtent: new OpenLayers.Bounds(-18.598705491875, -0.72081361875, 5.065845289375, 26.4046746625),
        maxExtent: new OpenLayers.Bounds(-62.6428949, -11.4905018, 49.85710501, 35.844773),
        controls: []
    });
    var urls = [
      "http://a.maps.geocms.co/tilecache.py?",
      "http://b.maps.geocms.co/tilecache.py?",
      "http://c.maps.geocms.co/tilecache.py?"
    ];
    this.map.addLayer(new OpenLayers.Layer.WMS("base", urls, {layers: "data01", format: "image/png"}));
    this.setupFeatureLayer();

    this.setupControls();

    this.map.zoomTo(0);

        var self = this;
    $("input[type='submit']").click(function() {
      if (self.layer.features.length > 0) {
        var searchBox = self.layer.features[0].geometry.bounds.toBBOX();
        $("#search_criteria_bbox").val(searchBox);
      }
      return true;
    });

  },

  setupControls: function() {
    var draw = new OpenLayers.Control.DrawFeature(this.layer, OpenLayers.Handler.Polygon);
    var panZoom = new OpenLayers.Control.PanZoomBar();
    panZoom.zoomWorldIcon = true;
    var controls = [new OpenLayers.Control.DragPan(), new OpenLayers.Control.Navigation(), panZoom];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });

    this.map.addControls([draw]);

    $("#draw").click(function() {
      if ($(this).attr("checked")) draw.activate();
      else draw.deactivate();
    });


  },

  setupFeatureLayer: function() {
    this.layer = new OpenLayers.Layer.Vector("Features");
    this.map.addLayer(this.layer);
  }
});