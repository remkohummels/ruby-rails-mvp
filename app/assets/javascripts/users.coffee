#= require tab-switcher
#= require currency
#= require modules/form.js.coffee
#= require validation/ajax
$ ->
  $('.block_member').on 'click', (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    confirmMesssage = $(this).attr('confirm')
    if confirm(confirmMesssage) && $('.group_rules_modal').length
      $rules_modal = $('.group_rules_modal').remodal()
      $rules_modal.open()
    return
