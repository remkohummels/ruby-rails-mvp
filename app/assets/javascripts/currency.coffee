$ ->
  $currency = $('.currency-item')
  $currency_field = $('#currency_id')

  if $currency_field.val()
    current_currency = $currency_field.val()
    current_currency = $(document).find '[data-id=\'' + current_currency + '\']'
    current_currency.addClass('active')

  $currency.on 'click', () ->
    $currency.removeClass('active')
    $(this).toggleClass('active')
    currency_id = $(this).data('id')
    $currency_field.val(currency_id)

  $(document).on 'ajax:success', () ->
    $choosen_currency = $('.currency-item.active')
    $choosen_currency.fadeOut(100).delay(100).fadeIn(500)