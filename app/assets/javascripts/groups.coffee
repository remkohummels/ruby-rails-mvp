#= require modules/form.js.coffee
#= require validation/ajax
#= require images
$ ->
  $area = $('.bz-group-controls')

  $area.each (i) ->
    if $(this).find('a').hasClass('switch_group')
      $(this).parents('.bz-group').addClass('active')
    else
      $(this).parents('.bz-group').removeClass('active')

  $area.on 'click', () ->
    $area = $(this)
    $(document).on 'ajax:success', () ->
      if $area.find('a').hasClass('choose_group')
        $area.parents('.bz-group').removeClass('active')
      else
        $('.bz-group').removeClass('active')
        $area.parents('.bz-group').addClass('active')
    $(document).on 'ajax:error', () ->
      $area.parents('.bz-group').removeClass('active')
      

