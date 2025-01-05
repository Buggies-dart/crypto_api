import 'package:crypto_app/Pages/data_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandlestickChart extends StatelessWidget {
  const CandlestickChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        title: const ChartTitle(text: 'Weekly Price Data'),
        primaryXAxis: const CategoryAxis(
          title: AxisTitle(text: 'Days'),
        ),
        primaryYAxis: const NumericAxis(
          title: AxisTitle(text: 'Price (USD)'),
          minimum: 2000, // Minimum Y value
          maximum: 4500, // Maximum Y value
          interval: 200, // Y-axis step
        ),
        series: <CandleSeries>[
          CandleSeries<CandlestickData, String>(
            dataSource: data,
            xValueMapper: (CandlestickData data, _) => data.day,
            lowValueMapper: (CandlestickData data, _) => data.low,
            highValueMapper: (CandlestickData data, _) => data.high,
            openValueMapper: (CandlestickData data, _) => data.open,
            closeValueMapper: (CandlestickData data, _) => data.close,
            enableTooltip: true,
            enableSolidCandles: true,
            bearColor: Colors.red, // Downtrend color
            bullColor: Colors.green, // Uptrend color
          ),
        ],
      zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true, // Enables dragging and panning
          enablePinching: true, // Enables zooming with pinch gestures
          enableDoubleTapZooming: true, // Allows zooming with double-tap
        ), ),
    );
  }
}
