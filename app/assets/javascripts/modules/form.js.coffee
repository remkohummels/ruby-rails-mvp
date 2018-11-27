#= require ../draft_item
$ ->
  $('#uploadBtn').on 'change', ->
    $('#uploadFile').val(@value)
    return
  $('form').submit(()->
    $('.submit-button').attr('disabled', true)
  )

$.fn.render_form_errors = (errors) ->
  @clear_previous_errors()
  model = @data('model')
  form = $(this)
  console.log('model', model);
  console.log('errors', errors);

  $.each errors, (field, messages) ->
    console.log('field', field);
    console.log('messages', messages);
    $input = form.find('[name="' + model + '[' + field + ']"]')
    $($input).parents('.panel-collapse').collapse('show');
    $input.addClass('parsley-error')
    description = $input.parents('.field_wrapper').find('.description')
    field_wrapper = $input.parents('.field_wrapper')
    if description.length > 0
      $(description).before "<h5 class='parsley-errors'>#{messages[0]}</>"
    else
      item_error = field_wrapper.find('.item_error')
      if field_wrapper.hasClass 'bid'
        errors_box = $(field_wrapper).parent().find('.item_errors')
        errors_box.text( "#{messages.join(', ')}")
        errors_box.addClass('parsley-errors')
      else if field_wrapper.hasClass 'select'
        $(field_wrapper).after "<h5 class='parsley-errors'>#{messages[0]}</>"
      else if field == 'banner'
        image_field = $input.parents('.image-field')
        image_field.addClass('parsley-error')
        images_wrapper =  image_field.parents('.image-fields-group')
        images_wrapper.prepend "<h5 class='parsley-errors'>#{messages[0]}</>"
      else if $input.length < 1
        $input = form.find('[name="' + field + '"]')
        $input.addClass('parsley-error')
        first_child = $input.parents('.form-group').children().first()
        error = $("<h5 class='parsley-errors'>#{messages[0]}</>")
        error.insertAfter(first_child)
      else if item_error.length > 0
        item_error.html("<h5 class='parsley-errors'>#{messages[0]}</>")
      else
        first_child = field_wrapper.children().first()
        # $(field_wrapper).append "<h5 class='parsley-errors'>#{messages.join(', ')}</>"
        error = $("<h5 class='parsley-errors'>#{messages[0]}</>")
        error.insertAfter(first_child)

$.fn.render_one_form_errors = (errors) ->
  @clear_previous_errors()
  this.prepend "<div class='help-block'>#{errors}</div>"

$.fn.clear_previous_errors = ->
  this.find('.help-block').remove()
  this.find('.parsley-error').removeClass 'parsley-error'
  this.find('.parsley-errors').remove()
