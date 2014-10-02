// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("page:change", function(){
  
  $(".chosen-select").chosen();
  
  $('.scroll-to').on('click', function(event) {
      event.preventDefault();
      $.scrollTo($('.pure-g'), 2000); 
  });
  $("#scroll-to").click(function() {
      $('html, body').animate({
              scrollTop: $(".pure-g").offset().top
      }, 1500);
  });
});
