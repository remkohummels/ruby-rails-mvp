// This is a manifest file that'll be compiled into base.js, which will include all the files
// listed below.

//--- Modernizr
//= require modernizr/modernizr.custom
//--- jQuery
//= require jquery
//--- Bootstrap
//= require bootstrap
//= require bootstrap-select
//= require moment

//--- Storage API
//= require jQuery-Storage-API/jquery.storageapi
//--- jQuery easing
//= require jquery.easing/js/jquery.easing
//--- Animo
//= require animo.js/animo
//--- Slimscroll
//= require slimScroll/jquery.slimscroll.min
//--- Screenfull
//= require screenfull/dist/screenfull
//--- jQuery UI
//= require jquery-ui/jquery-ui
//= require jquery_ujs

//= require OwlCarousel2/dist/owl.carousel.js
//= require jquery.remotipart
//= require jquery.countdown
//= require bootstrap-markdown-bundle
//= require dropzone
//= require jquery.raty
//= require ratyrate
//= require ./widget
//= require_tree ../angle/

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
