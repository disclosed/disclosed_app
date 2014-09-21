// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var handlers = {
  request: function(){
    $.ajax({
      type: "GET",
      dataType: "json",
      cache: false,
      url: "http://api.disclosed.ca:3000/contracts",
      success: function (data){
        console.log("successful call to api!", data);
      }
    });
  }
};

///// Events:

$(function(){
  console.log("hi");
  handlers.request();
});
