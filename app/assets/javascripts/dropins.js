$(function () {
    $("#datetimepicker1").datetimepicker({
        sideBySide: true
    });
    $(".view-dropin").tooltip({
        container: "body"
    });
    $(".edit-dropin").tooltip({
        container: "body"
    });
    $(".delete-dropin").tooltip({
        container: "body"
    });
    $(".selectpicker").selectpicker();
    $("#pay-now-button").click(function () {
        $(this).button("loading");
    });
    $('.email-dropin-creator').on('click', function () {
        $('#dropin_creator_emails_modal').modal('show');
    });
    $(".invite-skaters").on("click", function () {
        $("#invite_modal").modal("show");
    });
    $('.email-attendees').on('click', function () {
        $('#email_attendees_modal').modal('show')
    });
    $("#insert-date-time").on("click", function () {
        var message = $('#message');
        insertAtCaret(message.attr('id'), $('#dropin-date-time').text());
        message.focus();
    });
    $('#insert-price-per-player').on('click', function () {
        var message = $('#message');
        insertAtCaret(message.attr('id'), $('#dropin-price-per-player').text());
        message.focus();
    });

    $('#insert-rink').on('click', function () {
        var message = $('#message');
        insertAtCaret(message.attr('id'), $('#dropin-rink').text());
        message.focus();
    });
    $('#insert-terms-and-conditions').on('click', function () {
        var message = $('#message');
//        message.val(message.val() + $('#dropin-terms-and-conditions').text());
        insertAtCaret(message.attr('id'), $('#dropin-terms-and-conditions').text());
        message.focus();
    });

    $('#import-gmail-link').on('click', function () {
        $(this).button("loading");
        $()
    });

    var refreshIntervalId = null;
    var checkIfVariableIsSet = function () {
        if (typeof $('#users').autocomplete('instance') !== 'undefined') {
            $('#users').autocomplete('instance')._renderItem = function (ul, item) {

                var elem = $('<li>')
                    .data("item.autocomplete", item)
                    .append('<li class="media"><a class="pull-left" href="#"><img class="media-object" src=' + item.profile_picture + ' alt=""></a><div class="media-body"><h4 class="media-heading">' + item.name + '</h4>' + item.email + '</div></li>')
                    .appendTo(ul);
                console.log(item);
                return elem;
            };
            clearInterval(refreshIntervalId);
        }
    };
    refreshIntervalId = setInterval(checkIfVariableIsSet, 1000);

    function insertAtCaret(areaId, text) {
        var textArea = document.getElementById(areaId);
        var scrollPos = textArea.scrollTop;
        var strPos = 0;
        var br = ((textArea.selectionStart || textArea.selectionStart == '0') ?
            "ff" : (document.selection ? "ie" : false ) );
        if (br == "ie") {
            textArea.focus();
            var range = document.selection.createRange();
            range.moveStart('character', -textArea.value.length);
            strPos = range.text.length;
        }
        else if (br == "ff") strPos = textArea.selectionStart;

        var front = (textArea.value).substring(0, strPos);
        var back = (textArea.value).substring(strPos, textArea.value.length);
        textArea.value = front + text + back;
        strPos = strPos + text.length;
        if (br == "ie") {
            textArea.focus();
            var range = document.selection.createRange();
            range.moveStart('character', -textArea.value.length);
            range.moveStart('character', strPos);
            range.moveEnd('character', 0);
            range.select();
        }
        else if (br == "ff") {
            textArea.selectionStart = strPos;
            textArea.selectionEnd = strPos;
            textArea.focus();
        }
        textArea.scrollTop = scrollPos;
    }
});
