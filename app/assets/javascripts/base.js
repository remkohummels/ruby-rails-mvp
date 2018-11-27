// This is a manifest file that'll be compiled into base.js, which will include all the files
// listed below.
//--- jQuery
//= require jquery
//--- Bootstrap
//= require bootstrap



//= require jquery-ui
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery.screenfull

//= require angle/modules/navbar-search
//= require angle/modules/fullscreen


$(document).on('click', 'div.navbar-collapse ul li a', function(e) {
    $(this).closest('div.navbar-collapse').collapse('hide');
});