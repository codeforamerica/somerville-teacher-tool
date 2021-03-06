describe("McasGrowthChart", function() {

  describe(".fromChartData", function() {
    describe("no data series", function() {
      it("returns a new chart with no series", function() {
        var two_empty_series = $('<div data-mcas-series-math-growth="null" data-mcas-series-ela-growth="null"></div>');
        var chart = McasGrowthChart.fromChartData(two_empty_series);
        expect(chart.series).toEqual([]);
      });
    });
    describe("one data series", function() {
      it("returns a new chart with one series", function() {
        var one_empty_series = $('<div data-mcas-series-math-growth="[[2015,1,1,10]]" data-mcas-series-ela-growth="null"></div>');
        var chart = McasGrowthChart.fromChartData(one_empty_series);
        var math_series = chart.series[0];
        expect(math_series.data[0][1]).toEqual(10);
      });
    });
    describe("two data series", function() {
      it("returns a new chart with both series", function() {
        var zero_empty_series = $('<div data-mcas-series-math-growth="[[2015,1,1,20]]" data-mcas-series-ela-growth="[[2015,1,1,100]]"></div>');
        var chart = McasGrowthChart.fromChartData(zero_empty_series);
        var math_series = chart.series[0];
        expect(math_series.data[0][1]).toEqual(20);
      });
    });
  });
});
