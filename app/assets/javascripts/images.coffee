$ ->
  $(document).on 'change','.image_field_input',(e)->
    field = $(this)
    text_field = field.parents('.image-field').find('.image_field_text')
    filename = $(this).val()
    if /^\s*$/.test(filename)
      field.removeClass 'active'
      text_field.text 'No file chosen...'
    else
      text_field.addClass 'blue'
      filename = filename.replace('C:\\fakepath\\', '')
      console.log(filename)
      text_field.text(filename)
    return
  $(document).on 'click', '.remove_dz_image', ()->
    $(this).parent().hide()