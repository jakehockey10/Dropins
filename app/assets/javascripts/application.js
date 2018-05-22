// jquery-turbolinks "requires" that jquery.turbolinks
// be the second thing here and that turbolinks be the
// very last thing

//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
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
//= require turbolinks

//$(document).on('ready page:before-change', function () {
//  $('#main').fadeOut();
//});
//
//$(document).on('ready page:change', function () {
//  $('#main').hide();
//});
//
//$(document).on('ready page:update', function () {
//  $('#main').fadeIn();
//  init();
//});

$(document).on('turbolinks:load', handleEvent);

function handleEvent () {
  init();

  $('.dropdown-toggle').dropdown();
  $('[data-toggle="tooltip"]').tooltip();

  $('.cog-spin').mouseover(function (e) {
    $('.fa-cog').addClass('fa-spin');
    setTimeout(function () {
      $('.fa-cog').removeClass('fa-spin');
    }, 1000)
  }).mouseout(function (e) {
    $('.fa-cog').removeClass('fa-spin');
  });

  // Add an event listener
  document.addEventListener("need-a-selectpicker", function (e) {
    console.log(e.detail); // Prints "Example of an event"
  });
}

function init () {
  $(".selectpicker").selectpicker();
  $('.alert button.close').click(function () {
    $(this).parent().fadeOut('fast');
  });
}

var updateCountdown = function (idSelector) {
  // 140 is the max character length and 10 is the minimum
  var description = $(idSelector);
  if (description.length === 0) {
    return;
  }
  if (description.val() != null) {
    var remaining = 140 - description.val().length;
  }
  $('.countdown').text(remaining + ' characters remaining');
};