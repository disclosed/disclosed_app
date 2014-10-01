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
    },
    color: {
      pattern: ['#D35400', '#F62459', '#674172', '#EF4836', '#336E7B','#1E8BC3', '#26A65B', '#1BA39C']
    }
  });
});
