#= require OwlCarousel2/dist/owl.carousel.js

$(document).on 'click', '.modal-trigger', (e)->
  e.preventDefault()
  image_hash = $(this).data('image-hash')
  item_id = $(this).data('item-id')
  target = $(this).data('target-id')
  href = $(this).attr('href')
  data =
    item_id: item_id

  $.ajax({
    dataType: "json",
    url: href,
    data: data,
    success: (data)->
      $('.modal-container').empty()
      $('.remodal-wrapper').remove()
      $('.modal-container').append data.html
      $("[data-remodal-id='#{target}']").remodal().open()
      owl_carousel(image_hash)
  });

owl_carousel = (image_hash)->
  image_hash ||= ''
  onInitialized = (image_hash)->
    callback = ->
      $('.owl-carousel').trigger('to.owl.carousel', [image_hash, 100]);
    setTimeout callback, 500

  $('.owl-carousel').owlCarousel({
    loop: false,
    margin: 10,
    items: 1,
    onInitialized: onInitialized(image_hash),
    onInitialize: onInitialized(image_hash)
  })
