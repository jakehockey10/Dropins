$(document).on('turbolinks:load', handleEvent);
$(document).on('turbolinks:before-cache', handleEvent());

function handleEvent () {
  updateCountdown('#micropost_content');
  var content = $('#micropost_content');
  content.on('change', function () { return updateCountdown('#micropost_content'); });
  content.on('keyup', function () { return updateCountdown('#micropost_content'); });
}
