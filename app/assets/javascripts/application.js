//= require ./setup
//= require ./libraries/jquery-1.7.1.min
//= require ./libraries/OpenLayers
//= require_tree ./jquery.plugins
//= require ./libraries/underscore-min
//= require ./libraries/backbone-min
//= require ./libraries/rails
//= require ./libraries/sammy-latest.min
//= require ./libraries/js-model-0.10.0.min
//= require ./libraries/jquerymx-1.0.custom.min
//= require_tree ./sammy.plugins
//= require_tree ./src/geocms/models
//= require_tree ./src/geocms/helpers
//= require_tree ./src/geocms/collections
//= require_tree ./src/geocms/maps
//= require_tree ./src/geocms/views
//= require_tree ./src/geocms/templates

$(function () {
  $('#header #nav li:last').addClass('nobg');
  $('.block table tr:odd').css('background-color', '#fbfbfb');
});