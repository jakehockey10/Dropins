//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require turbolinks
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-select
//= require bootstrap-tokenfield
//= require underscore
//= require gmaps/google
//= require fullcalendar
//= require fullcalendar/gcal
//= require_tree .

$(document).on('ready page:before-change', function () {
  $('#main').fadeOut();
});

$(document).on('ready page:change', function () {
  $('#main').hide();
});

$(document).on('ready page:update', function () {
  $('#main').fadeIn();
  initAlertsAndHelpBoxes();
});

$(document).on('ready page:load', function () {
  initAlertsAndHelpBoxes();

  $('.toggle-menu').jPushMenu({closeOnClickLink: false});
  $('.dropdown-toggle').dropdown();
  $('[data-toggle="tooltip"]').tooltip();
});

function initAlertsAndHelpBoxes() {
  $('.alert button.close').click(function () {
    $(this).parent().fadeOut('fast');
//    $(this).parent().animate({ height: 0, opacity: 0 }, 'fast');
  });

  //var count = 0;
  //$('.help-block').each(function () {
  //  count++;
  //  var placement;
  //  if (count % 2 == 0) {
  //      placement = "left";
  //  } else {
  //      placement = "right";
  //  }
  //  var help_block = $(this).html();
  //  var control = $(this).prev();
  //  var control_id = control.attr('id');
  //  control.popover({
  //      html: true,
  //      trigger: "manual",
  //      content: help_block,
  //      placement: placement,
  //      title: 'uh oh :(' + '<button type="button" class="close" onclick="$(\'#' + control_id + '\').popover(\'hide\')">&times</button>',
  //      container: "body"
  //  });
  //  control.popover("show");
  //  $(this).remove();
  //  control.on('focus', function () {
  //      control.popover('show');
  //  });
  //});

  // Temp Fix: Remove after Bootstrap does the right thing and removes touchstart (see issue https://github.com/twitter/bootstrap/issues/6488)
  $('a.dropdown-toggle, .dropdown-menu, .dropdown-menu a, .dropdown-menu .dropdown-submenu a').on('touchstart.dropdown.data-api', function (e) {
    e.stopPropagation();
  });
  $(".selectpicker").selectpicker();
}