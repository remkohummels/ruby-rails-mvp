$ ->
  $('.livechat-button').on 'click', () ->
    # console.log('this click test')
    $('.zopim').find('iframe').contents().find('.meshim_widget_components_chatButton_Button').click()