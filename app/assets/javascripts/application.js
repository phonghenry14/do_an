// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require best_in_place
//= require jquery.atwho
//= require jquery.soulmate
//= require bootstrap
//= require chat
//= require private_pub
//= require turbolinks
//= require_tree .

$(function() {
  $('#notice').click(function() {
    $.ajax({
      url: '/activities/',
      type: 'GET'
    });
  $('#count-activities').html("");
  });
});


$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
});
