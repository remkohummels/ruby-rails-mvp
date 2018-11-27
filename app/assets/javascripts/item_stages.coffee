btn_clicked = false
$ ->
  $form = $('.new_item_form')
  $step = $('.step-fields')
  $btn_back = $('#prev-step')
  $btn_next = $('#next-step')
  $finish = $('#finish')
  $auc_only = $('.auc')
  $group = $('#group_select')

  if $('#step1').hasClass('active')
    window.location.hash = 'step1'
    $btn_next.attr("href", "#step2")
    isfree = $('#item_free_item').is(':checked')
    if isfree
      console.log('isf', isfree);
      $('#item_free_item').parents('.check').addClass('checked')
      $btn_next.attr("href", "#step3")
    else
      $btn_next.attr("href", "#step2")

  $(window).on 'hashchange', ->
    $hash = window.location.hash
    btn_clicked = false

    if $hash == '#step1'
      $step = $(document).find('.step-fields.active')
      $this_step = $(document).find('#s1')
      $step.removeClass('active')
      $this_step.addClass('active')

      $step_icon = $(document).find('.step')
      $this_step_icon = $(document).find('.step#step1')
      $step_icon.removeClass('active')
      $step_icon.removeClass('past')
      $this_step_icon.addClass('active')

      $btn_next.attr("href", "#step2")
      $btn_back.addClass('disabled')
    else
      $btn_back.removeClass('disabled')
    if $hash == '#step2'
      isfree = $('#item_free_item').is(':checked')
      $('.price_field').prop('disabled', isfree)
      $step = $(document).find('.step-fields.active')
      $this_step = $(document).find('#s2')
      $step.removeClass('active')
      $this_step.addClass('active')

      $step_icon = $(document).find('.step')
      $this_step_icon = $(document).find('.step#step2')
      $step_icon.removeClass('active')
      $this_step_icon.addClass('active')
      $this_step_icon.prev().addClass('past')

      $btn_next.attr("href", "#step3")
      $btn_back.attr("href", "#step1")
    if $hash == '#step3'
      $step = $(document).find('.step-fields.active')
      $this_step = $(document).find('#s3')
      $step.removeClass('active')
      $this_step.addClass('active')

      $step_icon = $(document).find('.step')
      $this_step_icon = $(document).find('.step#step3')
      $step_icon.removeClass('active')
      $step_icon.addClass('past')
      $this_step_icon.removeClass('past')
      $this_step_icon.next().removeClass('past')
      $this_step_icon.addClass('active')

      $btn_next.attr("href", "#step4")
      $btn_back.attr("href", "#step2")
    if $hash == '#step4'
      if ($('.dz-image').length == 0)
        $('.uploadiconbox').addClass('parsley-error')
        window.location.hash = 'step3'
      else
        $form.addClass('fully_valid_item')
        $(window).unbind('onbeforeunload')
        $('.uploadiconbox').removeClass('parsley-error')
        $step = $(document).find('.step-fields.active')
        $this_step = $(document).find('#s4')
        $step.removeClass('active')
        $this_step.addClass('active')

        $step_icon = $(document).find('.step')
        $this_step_icon = $(document).find('.step#step4')
        $step_icon.removeClass('active')
        $step_icon.addClass('past')
        $this_step_icon.removeClass('past')
        $this_step_icon.addClass('active')

        $btn_back.attr("href", "#step3")
        $btn_next.removeClass('active')
        $finish.addClass('active')
    else
      $btn_next.addClass('active')
      $finish.removeClass('active')

  $(document).on 'keydown', (e) ->
    if e.keyCode == 13
      if $('#step4').hasClass('active')
        $finish.click()
      else
        e
    return 

  $btn_next.on 'click', () ->
    btn_clicked = true
    $('.location').addClass('parsley-error')
    fully_valid = $('.fully_valid_item').length > 0 ? true : false
    if window.location.hash != '#step3' && !fully_valid
      $form.submit()

    $step_btn = $(document).find('.step.active')
    $step = $(document).find('.step-fields.active')
    $step_btn.removeClass('active')
    $step_btn.addClass('past')
    $step_btn.next().addClass('active')
    $step.removeClass('active')
    $step.next().addClass('active')
    if $('#step1').hasClass('active')
      $btn_back.addClass('disabled')
    else
      $btn_back.removeClass('disabled')
    if $('#step4').hasClass('active')
      $btn_next.removeClass('active')
      $finish.addClass('active')
    else
      $btn_next.addClass('active')
      $finish.removeClass('active')

  $('#item_free_item').on 'change', () ->
    isfree = $('#item_free_item').is(':checked')
    if isfree
      $btn_next.attr("href", "#step3")
    else
      $btn_next.attr("href", "#step2")
  $btn_back.on 'click', () ->
    $step_btn = $(document).find('.step.active')
    $step = $(document).find('.step-fields.active')
    $step_btn.removeClass('active')
    $step_btn.prev().removeClass('past')
    $step_btn.prev().addClass('active')
    $step.removeClass('active')
    $step.prev().addClass('active')
    if $('#step1').hasClass('active')
      $btn_back.addClass('disabled')
    else
      $btn_back.removeClass('disabled')
    if $('#step4').hasClass('active')
      $btn_next.removeClass('active')
      $finish.addClass('active')
    else
      $btn_next.addClass('active')
      $finish.removeClass('active')
  $(document).on 'click', '.item_is_free_btn', ()->
    console.log('click');
    isfree = $('#item_free_item').is(':checked')
    $('.price_field').prop('disabled', isfree)

  $(document).on 'click', () ->
    hash = window.location.hash
    isfree = $('#item_free_item').is(':checked')
    if hash == '#step1'
      if isfree
        $btn_next.attr("href", "#step3")
      else
        $btn_next.attr("href", "#step2")
    if hash == '#step2'
      $btn_next.attr("href", "#step3")
      $btn_back.attr("href", "#step1")
    if hash == '#step3'
      $btn_next.attr("href", "#step4")
      if isfree
        $btn_back.attr("href", "#step1")
      else
        $btn_back.attr("href", "#step2")
    if hash == '#step4'
      $btn_back.attr("href", "#step3")
  $(document).on 'ajax:error', () ->
    $step = $('.step-fields')
    hash = window.location.hash
    current_step = hash.replace('#step','') - 1
    console.log('current_step', current_step);
    if $step.size() > 0
      if $('.groups_checkboxes').find('input:checked').length == 0
        $('.choices-group').addClass('parsley-error')
      else if ( ($('.dz-image').length == 0) && (current_step > 2) )
        $('.uploadiconbox').addClass('parsley-error')

      id = $(document).find('.parsley-error').first().parents('.step-fields').prop('id')
      if id 
        id = +id.substring(1)
      console.log('ERR STEP ID', id)
      if current_step == id
        console.log('ERRORS on Validation')
      else 
        $('.parsley-error').removeClass('parsley-error')
        $('.parsley-errors').remove()

      window.location.hash = 'step' + id
