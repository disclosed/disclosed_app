// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("page:change", function(){
  
  $(".chosen-select").chosen();
  
  $("#scroll-to").on('click', function() {
    $('html, body').animate({
      scrollTop: $("#wrap_div").offset().top
    }, 1000);
  });
  $('.site-name').on('click', function(){
    $('html, body').animate({
      scrollTop: $(".pure-g.banner").offset().top
    }, 1000);
  });
  $("#magnifying-glass").on('click', function() {
    $('html, body').animate({
      scrollTop: $("#chart-area").offset().top
    }, 1000);
  });
  $("#newsletter-signup").on('click', function() {
    $('html, body').animate({
      scrollTop: $(".pure-g.newsletter").offset().top
    }, 1000);
  });
  $('.validate.pure-form.pure-form-stacked').bind('click', function(){
    (this).reset();
    $(this).closest('form').find('input:text, input:email select, textarea').val('');
  })
});


