$ ->
  $('#search_grid').click () ->
    $('.wlt_search_results').removeClass('list_style').addClass('grid_style')

  $('#search_list').click () ->
    $('.wlt_search_results').removeClass('grid_style').addClass('list_style')