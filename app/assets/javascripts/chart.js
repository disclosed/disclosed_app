$(function(){  
  var chart = c3.generate({
    bindto: '#chart',
    data: {
      columns: gon.chart_data
    }
  });
});
