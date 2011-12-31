//= require ./setup
//= require ./libraries/jquery-1.7.1.min
//= require ./libraries/OpenLayers
//= require_tree ./jquery.plugins
//= require ./libraries/underscore-min
//= require ./libraries/backbone-min
//= require ./libraries/rails
//= require ./libraries/droparea
//= require ./libraries/sammy-latest.min
//= require ./libraries/js-model-0.10.0.min
//= require ./libraries/jquerymx-1.0.custom.min
//= require_tree ./sammy.plugins
//= require ./src/geocms/models/geography
//= require ./src/geocms/models/info
//= require ./src/geocms/models/location
//= require ./src/geocms/models/comment
//= require ./src/geocms/models/search
//= require_tree ./src/geocms/helpers
//= require ./src/geocms/collections/comments
//= require ./src/geocms/collections/locations
//= require_tree ./src/geocms/maps
//= require_tree ./src/geocms/views/lightbox
//= require_tree ./src/geocms/views
//= require_tree ./src/geocms/templates

$(function () {
  $('#header #nav li:last').addClass('nobg');
  $('.block table tr:odd').css('background-color', '#fbfbfb');
});