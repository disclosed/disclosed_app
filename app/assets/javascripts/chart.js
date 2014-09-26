$(function(){  
  var chart = c3.generate({
    bindto: '#chart',
    data: {
      x: gon.chart_data[0][0],
      format: '%Y',
      columns: gon.chart_data
    },
    axis: {
        x: {
            type: 'timeseries',
            tick: {
               format: '%Y'
            } 
        }
    }
  });
  console.log(gon.chart_data);
});
