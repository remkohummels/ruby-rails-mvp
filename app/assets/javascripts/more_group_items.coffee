$ ->
  # when the load more link is clicked
  $more_btn = $('.more_group_items')
  $more_btn.click (e) ->
    e.preventDefault()
    group_id = $(this).attr('data-group')
    last_id = $(this).attr('data-item')
    # make an ajax call passing along our last user id
    url = $(this).attr('href')
    # console.log('url', url)
    $.ajax
      type: "GET",
      url: url,
      dataType: 'json',
      data: { 'group_id': group_id, 'item_id': last_id }
      success:(data) ->
        next_items = data.next_items
        response = data.html
        # console.log('next-items',next_items)
        $more_btn.before(response)
        if !next_items
          $more_btn.hide()
        return false
      error:(data) ->
        # console.log('error', data)
        return false