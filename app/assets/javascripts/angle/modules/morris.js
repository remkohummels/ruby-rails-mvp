// Morris
// ----------------------------------- 

(function(window, document, $, undefined){

  $(function(){

    if ( typeof Morris === 'undefined' ) return;

    var chartdata = [
        { y: "2006", a: 100, b: 90 },
        { y: "2007", a: 75,  b: 65 },
        { y: "2008", a: 50,  b: 40 },
        { y: "2009", a: 75,  b: 65 },
        { y: "2010", a: 50,  b: 40 },
        { y: "2011", a: 75,  b: 65 },
        { y: "2012", a: 100, b: 90 }
    ];

    var donutdata = [
      {label: "Download Sales", value: 12},
      {label: "In-Store Sales",value: 30},
      {label: "Mail-Order Sales", value: 20}
    ];

    // Line Chart
    // ----------------------------------- 

    if( document.getElementById('morris-line') )
      new Morris.Line({
        element: 'morris-line',
        data: chartdata,
        xkey: 'y',
        ykeys: ["a", "b"],
        labels: ["Serie A", "Serie B"],
        lineColors: ["#31C0BE", "#7a92a3"],
        resize: true
      });

    // Donut Chart
    // ----------------------------------- 
    if( document.getElementById('morris-donut') )
      new Morris.Donut({
        element: 'morris-donut',
        data: donutdata,
        colors: [ '#f05050', '#fad732', '#ff902b' ],
        resize: true
      });

    // Bar Chart
    // ----------------------------------- 
    if( document.getElementById('morris-bar') )
      new Morris.Bar({
        element: 'morris-bar',
        data: chartdata,
        xkey: 'y',
        ykeys: ["a", "b"],
        labels: ["Series A", "Series B"],
        xLabelMargin: 2,
        barColors: [ '#23b7e5', '#f05050' ],
        resize: true
      });

    // Area Chart
    // ----------------------------------- 
    if( document.getElementById('morris-area') )
      new Morris.Area({
        element: 'morris-area',
        data: chartdata,
        xkey: 'y',
        ykeys: ["a", "b"],
        labels: ["Serie A", "Serie B"],
        lineColors: [ '#7266ba', '#23b7e5' ],
        resize: true
      });

  });

})(window, document, window.jQuery);
