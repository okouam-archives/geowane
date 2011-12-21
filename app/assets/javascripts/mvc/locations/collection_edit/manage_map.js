$.Controller("ManageMap",
{
  init: function(el, options) {
    this.carto = new Carto();
    this.map = this.carto.map;
    this.footer = options.footer;
    this.carto.addCommonControls(this.map);
    this.layer = this.carto.createLayer("Features");
    this.setupControls();
    this.loadFeatures(options.locations, this.buildInfoTab.bind(this));
  },

  "a:contains('Save') click": function() {
    this.publish("geocms.locations-updating");
    var features = this.layer.features;
    var data = {locations: [], commit: "true"};
    for(var i = 0; i < features.length; i++) {
      var feature = features[i];
      var geometry = feature.geometry;
      data.locations[i] = {longitude:geometry.x, latitude: geometry.y, id: feature.attributes["id"]};
    }
    $.ajax({
      url: "/locations",
      data: data,
      success: this.hideActions(),
      context: this,
      type: "PUT",
      dataType: "json"
    });
    return false;
  },

  "a:contains('Cancel') click": function() {
    var features = this.layer.features;
    for(var i = 0; i < features.length; i++) {
      var longitude = features[i].attributes.longitude;
      var latitude = features[i].attributes.latitude;
      features[i].move(new OpenLayers.LonLat(longitude, latitude));
    }
    this.hideActions();
  },

  buildInfoTab: function(features) {
    var contents = this.footer.find(".contents");
    var wrapper = contents.children("ul").empty();
    var template = $.template(null,
      "<li> \
        <span><img src='${attributes.thumbnail}' style='height: 18px' /></span> \
        <span class='name'>${attributes.name}</span> \
      </li>"
    );
    var output = $($.tmpl(template, features));
    wrapper.append(output);
    this.footer.find(".tab").click(function() {
      if ($(this).text() == "show") $(this).text("hide");
      else $(this).text("show");
      contents.toggle();
      return false;
    });
  },

  showActions: function() {
    this.element.find(".portlet-header span").show();
  },

  hideActions: function() {
    this.element.find(".portlet-header span").hide();
  },

  loadFeatures: function(features, callback) {
    this.carto.displayNumberedFeatures(features, this.layer);
    callback(features);
  },

  setupControls: function() {
    var self = this;
    var drag = new OpenLayers.Control.DragFeature(this.layer, {
      onStart: function() {
        Carto.hideTipsy();
      },
      onComplete: function() {
        self.showActions();
      }
    });
    var tooltip = new OpenLayers.Control.SelectFeature(this.layer, {
      hover: true,
      multiple: false,
      highlightOnly: true,
      overFeature: function(feature) {
        Carto.showLabel(feature);
        $("body").css({cursor: "pointer"});
      },
      outFeature: function() {
        $("body").css({cursor: "default"});
        Carto.hideTipsy();
      }
    });

    var controls = [tooltip, drag];
    this.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
  }
});