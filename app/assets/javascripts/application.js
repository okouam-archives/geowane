//= require ./libraries/jquery-1.7.1.min
//= require ./libraries/OpenLayers
//= require_tree ./jquery.plugins
//= require ./libraries/underscore-min
//= require ./libraries/rails
//= require ./libraries/sammy-latest.min
//= require ./libraries/js-model-0.10.0.min
//= require ./libraries/jquerymx-1.0.custom.min
//= require_tree ./models
//= require_tree ./sammy.plugins
//= require_tree ./helpers
//= require_tree ./templates

$(function () {
  $('#header #nav li:last').addClass('nobg');
  $('.block table tr:odd').css('background-color', '#fbfbfb');
});