//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('ready page:load', function (){
    $('.view-rink').tooltip({
        container: 'body'
    });
    $('.edit-rink').tooltip({
        container: 'body'
    });
    $('.delete-rink').tooltip({
        container: 'body'
    });
});
