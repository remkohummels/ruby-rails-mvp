$ ->
  setTimeout () ->
    $('.alert').fadeOut(5000)
  , 3000

  setTimeout () ->
    $('.currency-banner').fadeOut(5000)
  , 60000

  $('.topnavbar .navbar-nav > li:not(.dropdown) a').on 'click', () ->
    $('.navbar-collapse').collapse('hide');
