// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("page:change", function(){
  
  $(".chosen-select").chosen();
  
  $("#scroll-to").click(function() {
      $('html, body').animate({
              scrollTop: $(".pure-g.explore").offset().top
      }, 1500);
  });
  $("#magnifying-glass").click(function() {
      $('html, body').animate({
              scrollTop: $(".pure-g.explore").offset().top
      }, 1500);
  });
  $("#newsletter-signup").click(function() {
      $('html, body').animate({
              scrollTop: $(".pure-g.newsletter").offset().top
      }, 1500);
  });
});


