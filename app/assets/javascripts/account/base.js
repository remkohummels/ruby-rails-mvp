// This is a manifest file that'll be compiled into base.js, which will include all the files
// listed below.
//--- jQuery
//= require jquery
//--- Bootstrap
//= require bootstrap

//= require jquery-ui
//= require jquery_ujs
//= require jquery.screenfull

//= require ../jquery.storageapi.min
//= require ../angle/modules/constants
//= require ../angle/modules/navbar-search
//= require ../angle/modules/fullscreen
//= require ../angle/modules/sidebar
//= require ../angle/modules/toggle-state
//= require ../angle/modules/trigger-resize
//= require ../angle/app.init

$(document).ajaxSend(function(event, request, settings) {
  $('.main-panel').block({
    message:null,
    css: { 
      border: 'none', 
      padding: '15px', 
      backgroundColor: '#000', 
      '-webkit-border-radius': '10px', 
      '-moz-border-radius': '10px', 
      opacity: .5, 
      color: '#fff' 
  }});
});

$(document).ajaxComplete(function(event, request, settings) {
  $('.main-panel').unblock();
});

$(document).on('click', 'div.navbar-collapse ul li a', function(e) {
    $(this).closest('div.navbar-collapse').collapse('hide');
});
