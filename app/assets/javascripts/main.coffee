# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ()->
  setTimeout (->
    $('div.alert.alert-notice').remove()
    return
  ), 5000
#  $('.owl-carousel-show').owlCarousel
#    items: 1
#    autoPlay: true
#    loop: false
#  $('.item-owl-carousel').owlCarousel
#    autoPlay: true
#    loop: false
#    responsive:
#      0:
#        items: 1
#        nav: false
#      600:
#        items: 2
#        nav: false
#      1000:
#        items: 4
#        loop: false
#  $('.owl-carousel').owlCarousel
#    autoPlay: true
#    loop: false
#    responsive:
#      0:
#        items: 1
#        nav: false
#      600:
#        items: 2
#        nav: false
#      1000:
#        items: 4
#        nav: false
#        loop: false
#

  # random = (owlSelector) ->
  #   owlSelector.children().sort(->
  #     Math.round(Math.random()) - 0.5
  #   ).each ->
  #     $(this).appendTo owlSelector
  #     return
  #   return

  # $('.item-slider').owlCarousel
  #   autoPlay: 3000
  #   nav: true
  #   loop: false
  #   navText: [
  #     "<i class='fa fa-angle-left'></i>",
  #     "<i class='fa fa-angle-right'></i>"
  #   ]
  #   responsiveClass: true
  #   responsive:
  #     0:
  #       items: 1
  #     600:
  #       items: 2
  #     1000:
  #       items: 4
  #   beforeInit: (elem) ->
  #     #Parameter elem pointing to $("#owl-demo")
  #     random elem
  #     return
  # return
