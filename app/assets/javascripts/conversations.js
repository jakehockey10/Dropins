$(document).on('ready page:load', function() {
  var conversation = $('#conversation')[0];
  if (conversation) $('#conversation').scrollTop(conversation.scrollHeight);

  $('#message_body').on('keyup', function() {
      if ($('#message_body').val().length > 0) {
          $('#send_message').button({disabled: false});
      } else {
          $('#send_message').button({disabled: true});
      }
  });

  //$('input.tokenize-recipients')
  //
  //  .on('tokenfield:createtoken', function (e) {
  //    var data = e.attrs.value.split('|')
  //    e.attrs.value = data[1] || data[0]
  //    e.attrs.label = data[1] ? data[0] + ' (' + data[1] + ')' : data[0]
  //  })
  //
  //  .on('tokenfield:createdtoken', function (e) {
  //    // Über-simplistic e-mail validation
  //    var re = /\S+@\S+\.\S+/
  //    var valid = re.test(e.attrs.value)
  //    if (!valid) {
  //      $(e.relatedTarget).addClass('invalid')
  //    }
  //  })
  //
  //  .on('tokenfield:edittoken', function (e) {
  //    if (e.attrs.label !== e.attrs.value) {
  //      var label = e.attrs.label.split(' (')
  //      e.attrs.value = label[0] + '|' + e.attrs.value
  //    }
  //  })
  //
  //  .on('tokenfield:removedtoken', function (e) {
  //    alert('Token removed! Token value was: ' + e.attrs.value)
  //  })
  //
  //  .tokenfield()
});