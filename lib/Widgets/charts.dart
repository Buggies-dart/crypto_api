import 'package:crypto_app/Pages/data_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CandlestickChart extends StatefulWidget {
  final String coinName;
  final String interval;
  const CandlestickChart({super.key, required this.coinName, required this.interval});

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
Future<List<Map<String, dynamic>>>? futureData;
  @override
void initState() {
    super.initState();
 futureData =  fetchCandleSticksAt1Hr();   
}
Future<List<Map<String, dynamic>>> fetchCandleSticksAt1Hr() async {
  List<String> cryptos = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'LTCUSDT'];
  String baseUrl = 'https://api.binance.com/api/v3/klines';
  List<Map<String, dynamic>> oneHrCandle = [];

  try {
for (String crypto in cryptos) {
final Uri url = Uri.parse('$baseUrl?symbol=$crypto&interval=${widget.interval}');
final res = await http.get(url);

if (res.statusCode == 200) {
final List<dynamic> data = jsonDecode(res.body);
        
List<Map<String, dynamic>> prices = data.map((kline) {
if (kline is List && kline.length >= 7) {
 return {
'crypto': crypto,
'timestamp': kline[0], // Open time (timestamp)
 'openPrice': double.tryParse(kline[1].toString()) ?? 0.0, // Open price
'highPrice': double.tryParse(kline[2].toString()) ?? 0.0, // High price
'lowPrice': double.tryParse(kline[3].toString()) ?? 0.0,  // Low price
'closePrice': double.tryParse(kline[4].toString()) ?? 0.0, // Close price
};
} else {
// Handle unexpected kline format
return {
'crypto': crypto,
'timestamp': 0,
'openPrice': 0.0,
'highPrice': 0.0,
'lowPrice': 0.0,
'closePrice': 0.0,
};
}}).toList();
        
oneHrCandle.addAll(prices);
    
} else {
throw Exception('Failed to fetch data for $crypto: ${res.statusCode}');
}
    }
  } catch (e) {
    throw Exception('Unexpected Error occurred while fetching data');
  }

  return oneHrCandle;
}

  @override
  Widget build(BuildContext context) {
return Scaffold(
body:
  FutureBuilder<List<Map<String, dynamic>>>( future: futureData, builder: (context, snapshot){
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}
else if(snapshot.hasError){
return   Center(
child:  Text('No Data Available: ${snapshot.error}', style: Theme.of(context).textTheme.bodyMedium,)
);
}
if (snapshot.hasData && snapshot.data != null) {
final hr1data = snapshot.data!;
final getData = hr1data.where((getEachData)=> getEachData['crypto'].substring(0, 3) == widget.coinName);  
  List <CandlestickData> candleData = getData.map((candles){
final timestamp = DateTime.fromMillisecondsSinceEpoch(candles['timestamp'] as int)
    .toString();    final openPrice =  (candles['openPrice'] as num).toDouble();
final highPrice =  (candles['highPrice'] as num).toDouble();
final lowPrice =  (candles['lowPrice'] as num).toDouble();
final closePrice =  (candles['closePrice'] as num).toDouble();

return CandlestickData(day: timestamp, open: openPrice, close: closePrice, high: highPrice, low: lowPrice);
  }).toList();
  final minPrice = candleData.map((data) => data.low).reduce((a, b) => a < b ? a : b);
final maxPrice = candleData.map((data) => data.high).reduce((a, b) => a > b ? a : b);
final dynamicInterval = (maxPrice - minPrice / 10).ceilToDouble();

return SfCartesianChart(
title: const ChartTitle(text: 'Weekly Price Data'), primaryXAxis: const CategoryAxis(
title: AxisTitle(text: 'Days'),
),
primaryYAxis:  NumericAxis(title: const AxisTitle(text: 'Price (USD)'), minimum: minPrice , // Minimum Y value
maximum: maxPrice , // Maximum Y value
interval: dynamicInterval // Y-axis step
),
series: <CandleSeries>[ CandleSeries<CandlestickData, String>(
dataSource: candleData, 
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
), );
  }
  throw Exception('No Data Found');
  }
  ),
    );
  }
}
