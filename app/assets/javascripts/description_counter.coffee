$ ->
  $desc = $('.description')
  $counter = $('.counter')

  $desc.on 'keyup', () ->
    count = 20 - $(this).val().length
    if count > 0
      $counter.text(count + ' symbols to complete description')
    else
      $counter.text('')
