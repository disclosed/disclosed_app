$(function(){  
  var chart = c3.generate({
    bindto: '#chart',
    data: {
      // all the input data for the chart belongs to the 'column' array
      columns: [
        ['x', date, date, date, date]
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 50, 20, 10, 40, 15, 25]
      ]
    },
    // One of the columns is specified as an x-axis. 
    axis: {
      x: {
        type: 'timeseries',
        tick: {
          format: "%Y-%m -%d"
        }
      }
    }
  });
});
