function updateCountdown(){
    // 140 is the max character length
  var micropostContent = $('#micropost_content');
  if (micropostContent.val() != null) {
      var remaining = 140 - micropostContent.val().length;
    }
    $('.countdown').text(remaining + ' characters remaining');
}

$(document).on('ready page:load', function () {
    updateCountdown();
    var content = $('#micropost_content');
    content.on('change', updateCountdown);
    content.on('keyup', updateCountdown);
});