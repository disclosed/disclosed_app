// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// var handlers = {
//   request: function(){
//     $.ajax({
//       type: "GET",
//       dataType: "json",
//       cache: false,
//       url: "http://api.disclosed.ca:3000/agencies",
//       success: function (data){
//         console.log("success!", data);
//       }
//     });
//   }
// }

///// Events:

$(function(){
  console.log("hi");
  //handlers.request;
  $.ajax({
      type: "GET",
      dataType: "json",
      cache: false,
      url: "http://api.disclosed.ca:3000/agencies",
      success: function (data){
        console.log("success!", data);
      }
    });
});
