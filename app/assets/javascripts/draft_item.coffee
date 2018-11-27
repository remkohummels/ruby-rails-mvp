$ ->
  form = $('form.save_to_draft')
  fully_valid = $('.fully_valid_item').length > 0 ? true : false
  form_presence = form.length != 0
  console.log('form_presence', form_presence)
  if !fully_valid && form_presence
    $fully_valid = false
    $(document).on 'ajax:success', () ->
      $fully_valid = true
    $(window).bind 'beforeunload', (e) ->
      if(btn_clicked)
        btn_clicked = false
        return undefined
      form = $('form.save_to_draft')
      fully_valid = $('.fully_valid_item').length > 0 ? true : false
      if $fully_valid
        fully_valid = true
      if !fully_valid
        console.log('save to draft BEFOREUNLOAD')
        location = window.location
        href = location.href
        item_id = location.pathname.split('/')[2]
        if item_id == 'new'
          action_url = '/item/save_to_draft'
        else
          action_url = '/item/' +  item_id + '/save_to_draft'
          form_data = form.serializeObject()
          $.ajax
            url: action_url
            type: 'POST'
            data: form_data
            dataType: 'json'
            success: (data) ->
              console.log('successfully posted')
      else
        window.onbeforeunload = ->
          null