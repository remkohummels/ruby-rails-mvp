$ ->
  $open_btn = $('.side_menu_open')
  $close_btn = $('.side_menu_close')
  $menu = $('.side_menu')

  $open_btn.on 'click', () ->
    $menu.addClass('open')
    $('body').prop('style', 'overflow: hidden')
  $close_btn.on 'click', () ->
    $menu.removeClass('open')
    $('body').prop('style', '')

  $(document).on 'click', (e) ->
    $menu = $('.side_menu')
    if $menu.hasClass('open')
      menu_offset = $menu.offset()
      if e.offsetX > $menu.outerWidth()
        $menu.removeClass('open')
        $('body').prop('style', '')