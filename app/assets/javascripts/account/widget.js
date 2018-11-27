$(function() {
  $('.widget-weather .timestamp').each(function() {
    var timestamp = parseInt($(this).text());
    // console.log(timestamp, moment(timestamp * 1000).format("YYYY-MM-DD h:mm A"));
    $(this).text(moment(timestamp * 1000).format("h A"));
  });

  $('.bid_timer').each(function(index, item) {
    d = new Date($(item).data('time'))
    $(item).countdown({
      until: new Date($(item).data('time')),
      layout: '{h10}{h1} : {m10}{m1} : {s10}{s1}'
    });
    $(item).removeClass('is-countdown')
  });
});
