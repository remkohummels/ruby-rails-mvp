$ ->
  $item = $('.send_on_change')

  $item.on 'change', ()->
    $(this).closest('form').submit()