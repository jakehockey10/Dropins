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
//= require jquery-ui
//= require autocomplete-rails
//= require turbolinks
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-select
//= require underscore
//= require gmaps/google
//= require fullcalendar
//= require gcal
//= require_tree .
$(document).on('ready page:before-change', function () {
    $('#main').fadeOut();
});

$(document).on('ready page:change', function () {
    $('#main').hide();
});

$(document).on('ready page:update', function () {
    $('#main').fadeIn();
});

$(document).on('ready page:load', function () {

    $('.alert button.close').click(function () {
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

//    $('.interested-button').on('click', function () {
//        var btn = $(this);
//        btn.button('loading');
//    });

});
