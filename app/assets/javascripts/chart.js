$(function(){  
  var chart = c3.generate({
    bindto: '#chart',
    data: {
      // all the input data for the chart belongs to the 'column' array
      columns: gon.chart_data
    }
    // One of the columns is specified as an x-axis. 
  //  axis: {
    //  x: {
      //  type: 'timeseries',
      //  tick: {
        //  format: "%Y-%m -%d"
       // }
    //  }
   // }
  });
});
