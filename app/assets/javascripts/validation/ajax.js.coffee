$(document).ready ()->

  $(document).on("ajax:success",".validate-form", (event, jqxhr, settings, exception) ->
    if jqxhr.location
      $(window).unbind 'beforeunload'
      window.location.href = jqxhr.location
      
    $(remove).fadeOut if jqxhr.remove
  ).on("ajax:error",".validate-form", (event, jqxhr, settings, exception) ->
    $(event.currentTarget).render_form_errors($.parseJSON(jqxhr.responseText))
    $('.submit-button').attr('disabled', false)
  )

  $(document).on("ajax:success","#login_user", (event, jqxhr, settings, exception) ->
    window.location.href = '/'
    $('.submit-button').attr('disabled', false)
  ).on("ajax:error","#login_user", (event, jqxhr, settings, exception) ->
    $('.submit-button').attr('disabled', false)
    $(event.currentTarget).render_one_form_errors($.parseJSON(jqxhr.responseText).error)
  )
