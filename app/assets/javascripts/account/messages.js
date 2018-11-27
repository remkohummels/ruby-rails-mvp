//= require ../modules/form.js.coffee
//= require ../validation/ajax
//= require ../messages
$(document).on('click', 'td.message-subject', function() {
  location.href='/account/messages/' + $(this).data('id');
});

$(document).on('click', 'button.btn-mail-reply', function() {
  id = $("input.mail-checkbox:checked").data("id");
  if(id) {
    location.href='/account/messages/new?reply_message='+id;
  }
});

$(document).on('click', 'button.btn-mail-delete', function() {
  ids = []
  $("input.mail-checkbox:checked").each(function() {
    ids.push($(this).data("id"));
  });
    $.ajax({
      url: "/account/messages/destroy_multiple.js",
      type: 'DELETE',
      data: {ids: ids},
      success: function(data) {
        eval(data);
      }
    });
});

