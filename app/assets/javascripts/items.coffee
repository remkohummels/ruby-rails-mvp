#= require dropzone
#= require jquery.countdown
#= require item_stages
#= require modules/form.js.coffee
#= require validation/ajax
#= require modals
#= require _fotorama

$ ->

  $('.bz-product-item-wrapper').each (index, item) ->
    time_left = $(item).data('left')
    if (time_left)
      time_left = +time_left * 1000
      if time_left < 0
        time_left = 0
      console.log('time_left', time_left)
      setTimeout () ->
        item_id = $(item).data('id')
        $.ajax
          type: "POST",
          url: "/finish/" + item_id,
          success:(data) ->
            $(item).fadeOut(5000)
            return true
          error:(data) ->
            return false
      , time_left

  $('#item_free_item').click ()->
    if $(this).is(':checked')
      $('.price').fadeOut()
    else
      $('.price').fadeIn()

  $('.check').on 'click', ()->
    $(this).toggleClass('checked')
    if $(this).hasClass('checked')
      $(this).find('input[type="checkbox"]').prop('checked', true)
    else
      $(this).find('input[type="checkbox"]').prop('checked', false)


  $('.bid_timer').each (index, item)->
    d = new Date($(item).data('time'))
    $(item).countdown({
      until: new Date($(item).data('time')),
      layout: '<div class="c-wrap"><h2 class="bz-title">{d10}{d1}</h2><h4 class="bz-subtitle">days</h4><span> : </span></div>
        <div class="c-wrap"><h2 class="bz-title">{h10}{h1}</h2><h4 class="bz-subtitle">hrs</h4><span> : </span></div>  
        <div class="c-wrap"><h2 class="bz-title">{m10}{m1}</h2><h4 class="bz-subtitle">mins</h4><span> : </span></div>
        <div class="c-wrap"><h2 class="bz-title">{s10}{s1}</h2><h4 class="bz-subtitle">sec</h4></div>'
    });
    $(item).removeClass('is-countdown')
    
  $('#item_condition').addClass('form-control')

  $('.timer2').each (index, item)->
    $(item).countdown({
      until: new Date($(item).data('time')),
      layout: '<b>{d<}{dn} {dl} {d>}{h<}{hn} {hl} {h>}{m<}{mn} {ml} {m>}{s<}{sn} {sl}{s>}</b> left!'
    });

  Dropzone.autoDiscover = false;
  $(".dropzone").dropzone(
    {
      url: $(".dropzone").data('action')
      maxFilesize: 10
      maxFiles: $(".dropzone").data('count')
      addRemoveLinks: true
      dictDefaultMessage: "DROP THE IMAGE HERE"
      dictMaxFilesExceeded: 'You can not add more attachments.'
      acceptedFiles: ".jpeg,.jpg,.gif,.png"
      init: ()->
        this.on 'removedfile', (file)->
          if file.xhr || file.id?
            id = if file.xhr?.response? then (JSON.parse(file.xhr.response).id) else file.id
            if file.mockFile? && file.mockFile is true then  this.options.maxFiles++
            $.ajax
              url: "/images/" + id,
              type: 'DELETE'
    }
  )
