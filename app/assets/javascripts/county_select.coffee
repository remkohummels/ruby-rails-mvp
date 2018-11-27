$ $ ->
  $('.selectpicker').selectpicker()
  return

$(document).on 'change','.bz-country-select',(e)->
  $(this).parents('form').submit()
  location.reload()