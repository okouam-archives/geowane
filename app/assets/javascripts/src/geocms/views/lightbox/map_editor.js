GeoCMS.Views.Lightbox.MapEditor = Backbone.View.extend({

  TEMPLATE:
    "<ul> \
      <% if (attributes.boundary_0) { %> \
        <li> \
          <label><%= attributes.boundary_0.classification %></label> \
          <%= attributes.boundary_0.name %> \
        </li> \
      <% } %> \
      <% if (attributes.boundary_1) { %> \
        <li> \
          <label><%= attributes.boundary_1.classification %></label> \
          <%= attributes.boundary_1.name %> \
        </li> \
      <% } %> \
      <% if (attributes.boundary_2) { %> \
        <li> \
          <label><%= attributes.boundary_2.classification %></label> \
          <%= attributes.boundary_2.name %> \
        </li> \
      <% } %> \
      <% if (attributes.boundary_3) { %> \
        <li> \
          <label><%= attributes.boundary_3.classification %></label> \
          <%= attributes.boundary_3.name %> \
        </li> \
      <% } %> \
      <% if (attributes.boundary_4) { %> \
        <li> \
          <label><%= attributes.boundary_4.classification %></label> \
          <%= attributes.boundary_4.name %> \
        </li> \
      <% } %> \
      <li><label>Longitude</label><%= attributes.longitude %></li> \
      <li><label>Latitude</label><%= attributes.latitude %></li> \
    </ul>",

  initialize: function(options) {
    if (options.location) this.associate(options.location);
    this.is_new_location = options.is_new_location;
  },

  associate: function(location) {
    if (this.location) this.location.geography.unbind("change", this.render);
    this.location = location;
    this.location.geography.unbind("change", this.render);
    this.location.geography.bind("change", this.render, this);
  },

  render: function() {
    $("#faceboxmap").empty();
    this.carto = new Carto("faceboxmap");
    this.layer = this.prepareMap();
    var point = new OpenLayers.Geometry.Point(this.location.get("longitude"), this.location.get("latitude"));
    var feature = new OpenLayers.Feature.Vector(point);
    feature.attributes["thumbnail"] = "/assets/icons/1.gif";
    this.layer.destroyFeatures();
    this.layer.addFeatures([feature]);
    original_geometry = this.layer.getDataExtent().getCenterLonLat();
    this.carto.map.setCenter(original_geometry, 6);
    if (!this.is_new_location) {
      var template = _.template(this.TEMPLATE, this.location.geography);
      var wrapper = $("#geo-details");
      wrapper.empty();
      wrapper.append(template);
      $("#" + this.el.id).find(".warning").empty();
    }
  },

  prepareMap: function() {
    this.carto.addCommonControls();
    var landmark_layer = this.carto.createLayer("Landmarks");
    new GeoCMS.Maps.Signposting(landmark_layer);
    var layer = this.carto.createLayer("Features");
    var drag = new OpenLayers.Control.DragFeature(layer, {
      onStart: function() {
        $("#" + this.el.id).find(".warning").html("The location has been modified. Click 'Accept' to keep changes.").show();
      }.bind(this),
      onComplete: function(evt) {
       this.trigger("location-moved", {longitude: evt.geometry.x, latitude: evt.geometry.y});
      }.bind(this)
    });
    var controls = [drag];
    this.carto.map.addControls(controls);
    $.each(controls, function (index, item) {
      item.activate();
    });
    return layer;
  }

});

