class CandlestickData{
   final String day; 
  final double open; 
  final double close; 
  final double high;
  final double low; 

CandlestickData({required this.day, required this.open, required this.close, required this.high, required this.low});
}

// Dummy Data

final List<CandlestickData> data = [
  CandlestickData(day: 'SUN', open: 3500, close: 4000, high: 4200, low: 3400),
  CandlestickData(day: 'MON', open: 4000, close: 3700, high: 4100, low: 3600),
  CandlestickData(day: 'TUE', open: 3700, close: 3900, high: 4000, low: 3500),
  CandlestickData(day: 'WED', open: 3900, close: 4100, high: 4200, low: 3800),
  CandlestickData(day: 'THU', open: 4100, close: 4300, high: 4400, low: 4000),
  CandlestickData(day: 'FRI', open: 4300, close: 4150, high: 4500, low: 4100),
  CandlestickData(day: 'SAT', open: 4150, close: 4200, high: 4300, low: 4100),
];