$ ->
  window.change_message_status = (message_id)->
    $.ajax
      url: "/messages/status/" + message_id,
      type: 'POST'
      success: (data) ->
        counter = $('.unread_msg_counter')
        unread_count = +counter.text()
        if unread_count > 1
          new_count = unread_count - 1
          counter.text(new_count)
        else
          counter.parent().hide()
