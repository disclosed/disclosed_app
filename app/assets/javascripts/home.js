// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("page:change", function(){
  
  $(".chosen-select").chosen();
  
  $('.search-form').on('click', function(event){
    event.preventDefault();
    $(this).next('.hidden-form').show();
  });
});
