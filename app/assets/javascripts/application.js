// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require materialize-sprockets
//= require materialize-form
//= require materializedatetimepicker
//= require_tree .
// @import "materialize";
// @import "https://fonts.googleapis.com/icon?family=Material+Icons";

// Flash fade
$(document).ready(function () {
    window.materializeForm.init()
});
$(function () {
    $('.alert-box').fadeIn('normal', function () {
        $(this).delay(3700).fadeOut();
    });
});
var currDate = new Date()
$('.datepicker').on('mousedown', function preventClosing(event) {
    event.preventDefault();
});
$(document).ready(function () {
    console.log("hahaha")
    M.AutoInit();
    // $(".dropdown-trigger").dropdown();
    // $("select").formSelect();
    $(".datepicker").datepicker({
        format: "mmmm dd, yyyy",
        //defaultDate: Date.currDate,
        setDefaultDate: currDate,
        maxDate: currDate,
        yearRange: [currDate.getFullYear()-100, currDate.getFullYear()]
    });
})
$(document).ready(function() {
    M.AutoInit();
    var DateField = MaterialDateTimePicker.create($('#datetime'));
})