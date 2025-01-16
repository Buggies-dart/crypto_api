class CandlestickData{
   final String day; 
  final double open; 
  final double close; 
  final double high;
  final double low; 

CandlestickData({required this.day, required this.open, required this.close, required this.high, required this.low});

@override
  String toString() {
    return 'CandlestickData(day: $day, open: $open, high: $high, low: $low, close: $close)';
  }

}

// Dummy Data

