import 'dart:async';

import 'package:crypto_app/Pages/crypto_info.dart';
import 'package:crypto_app/Theme/palette.dart';
import 'package:crypto_app/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
class _HomePageState extends ConsumerState<HomePage> {
Future<Map<String, dynamic>>? fetchDataFuture;
@override
void initState() {
    super.initState();
  fetchDataFuture = fetchData();   
}

Future<List<Map<String, dynamic>>> fetchCryptoPrices() async{
Future.delayed(const Duration(seconds: 2));
String cryptos = '["BTCUSDT","ETHUSDT","SOLUSDT","LTCUSDT"]';
try {
  final url = Uri.parse( 'https://api.binance.com/api/v3/ticker/price?symbols=$cryptos');
final res = await http.get(url);
if (res.statusCode == 200) {  
  final List<dynamic> data = jsonDecode(res.body);
  
return data.map((item) {
 final doublePrice = double.parse(item['price']);
  return {"symbol": item['symbol'], "price": doublePrice.toStringAsFixed(2)};
}).toList();
}
else{
  throw Exception('Error occurred');
}

} catch (e) {
 throw Exception('Error occurred: $e');
}

}

Future<List<Map<String, dynamic>>> fetchPricesAt1Hr() async {
 
  List<String> cryptos = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'LTCUSDT'];
  String baseUrl = 'https://api.binance.com/api/v3/klines';
  List<Map<String, dynamic>> allPrices = [];

  try {
    for (String crypto in cryptos) {
      final Uri url = Uri.parse('$baseUrl?symbol=$crypto&interval=1h');
      final res = await http.get(url);
if (res.statusCode == 200) { final List<dynamic> data = jsonDecode(res.body);
List<Map<String, dynamic>> prices = data.map((kline) {
  if (kline is List && kline.length >= 5) {
return {
'crypto' : crypto, 
'timestamp': kline[0],             
'closePrice': double.tryParse(kline[4].toString()) ?? 0.0, // Close price
};
} else {
return {
'crypto' : crypto, 
'timestamp': 0,
'closePrice': 0.0,
};
}
}).toList();
allPrices.addAll(prices);
      
} else {
throw Exception('Failed to fetch data for $crypto: ${res.statusCode}');
}
}
} catch (e) {
throw Exception('Unexpected Error occurred while fetching data');
}
return allPrices;
}

Future<Map<String, dynamic>> fetchData () async{

final fetchCoinPrices = await fetchCryptoPrices();
final fetch1hrPrices =  await fetchPricesAt1Hr();

return {
'fetchCoinPrices' : fetchCoinPrices, 'fetch1hrPrices' : fetch1hrPrices
};

}
  @override
  Widget build(BuildContext context) {
  final themeToggle = ref.watch(themeProvider);
  final sizeHeight = MediaQuery.of(context).size.height;
  final sizeWidth = MediaQuery.of(context).size.width;
return Scaffold(
body: SingleChildScrollView( scrollDirection: Axis.vertical,
  child: Column(
    children: [
FutureBuilder( future: fetchDataFuture, builder: (context, snapshot){
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: LinearProgressIndicator(),
);
}
else if (snapshot.hasError){
return Center(child: Text('Error: ${snapshot.error}'));
}
final cryptoPrices = snapshot.data!['fetchCoinPrices'] as List<Map<String, dynamic>>;
final cryptoPricesAt1hr = snapshot.data!['fetch1hrPrices'] as List<Map<String, dynamic>>;

double worth = 1.1459;
final networth =  double.parse(cryptoPrices[0]['price'])  * worth;
      
return Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
children: [
 SizedBox( height: sizeHeight/25),
Container( color: null,
child:  Row(
children: [
const Row(children: [
Padding(
 padding: EdgeInsets.only(left: 10),
child: CircleAvatar(
backgroundImage: AssetImage('assets/images/cgsi.png'),
),
),
SizedBox( width: 10),
Text('Labisi Buggies')
],
),
const Spacer(),
Padding(
padding:  const EdgeInsets.only( right: 10),
child: CircleAvatar( child: IconButton(onPressed: (){ }, icon:  const Icon(Icons.notifications),)),
),  
],
),
),
Padding(
padding:  EdgeInsets.only(top: sizeHeight/30, left: sizeWidth/60,right: sizeWidth/60),
child: Material( elevation: 20, shadowColor: Colors.black45,
child: Container( decoration: BoxDecoration(
gradient:  LinearGradient(colors: [
Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer
]),
borderRadius: BorderRadius.circular(10)),
child: Column( crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding:  EdgeInsets.only( left:sizeWidth/30, top: sizeHeight/35), child:  const Text('Available Balance', style: StyleText.largeBodyText),
),   
Padding(
padding: const EdgeInsets.only(left: 15),
child: Row( children:  [
Text(worth.toString(), style: Theme.of(context).textTheme.titleLarge),
SizedBox( width: sizeWidth/40),

Padding(
padding:  const EdgeInsets.only(top: 7),
child: Container( width: sizeWidth/9, height: sizeHeight/40,  decoration:  BoxDecoration( color: Palette.chipColor,
borderRadius: BorderRadius.circular(6)),
child: const Center(child:  Text('BTC', style: TextStyle(
fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16
),
)
),
),
),
const Spacer(),
const Padding(
padding: EdgeInsets.only( right: 10),
child: Icon(Icons.refresh),
)],
),
),
Padding(
padding:  const EdgeInsets.only(left: 15),
child:  Text('${networth.toStringAsFixed(2)} USD', style: StyleText.largeBodyText,),
),

SizedBox(height: sizeHeight/30),

Padding(
padding:  EdgeInsets.only(bottom: sizeHeight/55),
child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
chipFunc(Image.asset('assets/images/bitcoin.png', fit: BoxFit.contain, width: sizeWidth/10), 'Send'),
chipFunc(Image.asset('assets/images/bitcoin.png', fit: BoxFit.contain, width: sizeWidth/10), 'Withdraw'),
chipFunc(  Icon(Icons.add_circle_outline, size: sizeWidth/10), 'More'),
chipFunc(  Icon(Icons.grid_view, size:sizeWidth/10), 'Buy'),
  ],
  ),
)])
 ),
),
),

 SizedBox( height: sizeHeight/50 ),
        
Padding(
padding: const EdgeInsets.all(8.0),
child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('PORTFOLIO', style: Theme.of(context).textTheme.bodyMedium,),
const Row(
children: [
Text('24h'),
Icon(Icons.swap_vert)
],
)
],
),
),

Flexible( 
child: ListView.builder( itemCount: cryptoPrices.length, shrinkWrap: true, scrollDirection: Axis.vertical,
padding: const EdgeInsets.only(top: 0),
itemBuilder: (context, index){
List<Map> coins = [
{
'coinName' : 'Bitcoin', 
'color' : Palette.chipColor,
'image' : 'assets/images/bitcoin2.png'
},
{
'coinName' : 'Ethereum', 
'color' : Palette.ethColor,
'image' :'assets/images/eth.png'

},
{
'coinName' : 'Litecoin', 
'color' : Palette.ltcColor,
'image' : 'assets/images/litecoin.png'},
              {
'coinName' : 'Solana', 
 'color' : Palette.solColor,
 'image' : 'assets/images/sol.png'

},
];
final price = cryptoPrices[index];
final symbol = price['symbol'];
final displaySymbol = symbol.substring(0, 3);
final getCryptoPricesAt1hr = cryptoPricesAt1hr.where((getPrice)=> getPrice['crypto'] == price['symbol']).toList();
List<FlSpot> spots = getCryptoPricesAt1hr.map((price) {
final timestamp = (price['timestamp'] as num).toDouble(); 
final closePrice = (price['closePrice'] as num).toDouble();
  return FlSpot(timestamp, closePrice);
}).toList();

return SingleChildScrollView( scrollDirection: Axis.vertical,
child: GestureDetector( onTap: (){
 Navigator.push(context, MaterialPageRoute(builder: (context){
return CryptoInfo(coinName: displaySymbol, coinPrice: price['price'], coinImg: coins[index]['image'], color: coins[index]['color'],);
}));
},
child: portfolio(displaySymbol, price['price'], coins[index]['coinName'], displaySymbol == 'BTC'?
worth.toString(): '0', coins[index]['image'] as String, coins[index]['color'], spots),
),
  );
           
 }),
),

SizedBox( height: sizeHeight/50),

SwitchListTile.adaptive(value: themeToggle.themeMode == ThemeMode.dark , onChanged: (
(value) {
setState(() {
themeToggle.toggleTheme();
});
}
)) ],
 );
}),
],
  )
),
    );
  }

Widget portfolio(String text, String price, String coinName, String asset, String img, Color color, List <FlSpot> spots 
) {
return Padding(
padding: const EdgeInsets.all(8.0),
child: Container(  width: double.infinity, height: MediaQuery.of(context).size.height/10,
decoration: BoxDecoration( borderRadius: BorderRadius.circular(10), color: color),
  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
 Padding(
padding: const EdgeInsets.only( top: 10, bottom: 10, left: 10 ),
child: Container( width:  MediaQuery.of(context).size.width/6, 
decoration: BoxDecoration( borderRadius: BorderRadius.circular(15),  color: Colors.white,),
child:  Center(child:  Image.asset(img, width: 30, fit: BoxFit.contain,)),
   ),
 ),
Padding(
padding:   EdgeInsets.only(top: MediaQuery.of(context).size.height/60),
child:  Column(
children: [
Text(text, style: const TextStyle(
  fontWeight: FontWeight.bold, fontSize: 25, color: Colors.orange
),),
 Text(coinName, style: const TextStyle(color: Colors.black45, fontSize: 15),)  ],
),
) ,
 
SizedBox( width: MediaQuery.of(context).size.width/7, height: MediaQuery.of(context).size.height/25,
child: LineChart(
LineChartData(
gridData: const FlGridData(show: false),
titlesData: const FlTitlesData(show: false),
borderData: FlBorderData(show: false),
lineBarsData: [
LineChartBarData( color: Colors.orange, spots: spots, isCurved: true,   isStrokeCapRound: true, 
dotData: const FlDotData(show: false),
belowBarData: BarAreaData( cutOffY: 1.3, applyCutOffY: true, show: true,
gradient: LinearGradient( begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0,5],
colors: [
Colors.orange.withOpacity(1), Palette.chipColor.withOpacity(0.02)
])
                         
),
),
],
),
),
),

Padding(
padding:  EdgeInsets.only(right: 12, top: MediaQuery.of(context).size.height/40),
child: Column(
  children: [
Text('\$$price USD', style: Theme.of(context).textTheme.displayLarge),
Text('$asset $text', style: StyleText.largeBodyText,)
],
  
),
)
],
  ),
),
);
  }


Widget chipFunc(Widget img, String text) {
    return Column(
  children: [
    CircleAvatar( radius: MediaQuery.of(context).size.width/13, backgroundColor: Palette.fadedWhiteColor,
    child: img
    ),
 Text( text, style: StyleText.largeBodyText,) ],
);
  }
}


