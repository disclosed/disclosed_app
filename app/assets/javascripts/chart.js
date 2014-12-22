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
            label: 'year total',
            tick: {
               format: '%Y'
            } 
        },
        y: {
           label: 'contract value ($1000)'
        }
    },
    color: {
      pattern: ['#141E9C', '#B72D2F', '#79B337', '#664081', '#1189A4','#F1701B', '#7897C9', '#000000']
    },
    transition: {
      duration: 1000
    }
  });
  setTimeout(function(){
    chart.load({
    });
  }, 2000);
});
