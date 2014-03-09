// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .
$(document).ready(function () {
    $(".alert button.close").click(function () {
        $(this).parent().fadeOut('fast');
//        $(this).parent().animate({ height: 0, opacity: 0 }, 'fast');
    });

    var count = 0;
    $('.help-block').each(function () {
        count++;
        var placement;
        if (count % 2 == 0) {
            placement = "left";
        } else {
            placement = "right";
        }
        var help_block = $(this).html();
        var control = $(this).prev();
        var control_id = control.attr('id');
        control.popover({
            html: true,
            trigger: "manual",
            content: help_block,
            placement: placement,
            title: 'uh oh :(' + '<button type="button" class="close" onclick="$(\'#' + control_id + '\').popover(\'hide\')">&times</button>',
            container: "body"
        });
        control.popover("show");
        $(this).remove();
        control.on('focus', function () {
            control.popover('show');
        });
    });

//    $("form").validate({
//        rules: {
//            "user[password]": {
//                minlength: 6,
//                required: true
//            }
//        },
//        showErrors: function(errorMap, errorList) {
//            $.each(this.successList, function (index, value) {
//                return $(value).popover("hide");
//            });
//            return $.each(errorList, function (index, value) {
//                var popover;
//                popover = $(value.element).popover({
//                    trigger: "manual",
//                    placement: "right",
//                    content: value.message,
//                    template: "<div class=\"popover\"><div class=\"arrow\"></div><div class=\"popover-inner\"><div class=\"popover-content\"><p></p></div></div></div>"
//                });
//                popover.data("bs.popover").options.content = value.message;
//                return $(value.element).popover("show");
//            })
//        }
//    })
});
