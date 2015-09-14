$(document).on('ready page:load', function () {
    updateCountdown('#micropost_content');
    var content = $('#micropost_content');
    content.on('change', function () { return updateCountdown('#micropost_content'); });
    content.on('keyup', function () { return updateCountdown('#micropost_content'); });
});
