$ ->
  $(document).scroll ->
    distance = $(document).scrollTop()
    # console.log(distance)
    if distance > 120
      # $('.bz-dashboard').addClass('sticked')
      $('.active-group-banner').addClass('sticked')
    else
      # $('.bz-dashboard').removeClass('sticked')
      $('.active-group-banner').removeClass('sticked')