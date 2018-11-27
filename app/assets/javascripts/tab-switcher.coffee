$ ->
  $tab = $('.bz-tab')

  $tab.click () ->
    $tab.removeClass('active')
    $(this).toggleClass('active')