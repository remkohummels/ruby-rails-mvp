$ ->
  $(document).on 'click', '.open-disput', (e)->
    e.preventDefault()
    target = $(this).data('target-id')
    href = $(this).attr('href')
    item_id = $(this).data('item-id')
    data =
      item_id: item_id

    $.ajax({
        dataType: "json",
        url: href,
        data: data,
        success: (data)->
          $('.modal-container').empty()
          $('.remodal-wrapper').remove()
          $('.modal-container').append data.html
          $("[data-remodal-id='#{target}']").remodal().open()
      });

  $(document).on 'click', '.resolve-disput', (e)->
    e.preventDefault()
    target = $(this).data('target-id')
    href = $(this).attr('href')
    disput_id = $(this).data('disput-id')
    data =
      disput_id: disput_id

    $.ajax({
        dataType: "json",
        url: href,
        data: data,
        success: (data)->
          $('.modal-container').empty()
          $('.remodal-wrapper').remove()
          $('.modal-container').append data.html
          $("[data-remodal-id='#{target}']").remodal().open()
      });
