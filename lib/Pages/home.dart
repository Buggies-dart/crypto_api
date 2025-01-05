import 'package:crypto_app/Pages/crypto_info.dart';
import 'package:crypto_app/Theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
@override
void initState() {
    super.initState();
    fetchCryptoPrices(); 
  }

Future<List<Map<String, dynamic>>> fetchCryptoPrices() async{

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

Future<Map<String, dynamic>> fetchPriceAt1hr() async{

List<String> cryptos = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'LTCUSDT'];
String baseUrl = 'https://api.binance.com/api/v3/klines';
Map<String, dynamic> fetchedPricesat1hr = {};
 try {
   for (var crypto in cryptos) {
  final Uri url = Uri.parse('$baseUrl?symbol=$crypto&interval=1h');
  final res = await http.get(url);

  if (res.statusCode == 200) {
    fetchedPricesat1hr[crypto] = jsonDecode(res.body);
  }
  else {
  print('Failed to fetch data for $crypto: ${res.statusCode}');
      }
}
 } catch (e) {
   throw Exception('Some Error Occurred');
 }
 return fetchedPricesat1hr;
}
 void displayCryptoData() async {
  // Fetch the data
  Map<String, dynamic> cryptoData = await fetchPriceAt1hr();

  // Access each symbol's data separately
  var btcData = cryptoData['BTCUSDT'];
  var ethData = cryptoData['ETHUSDT'];
  var solData = cryptoData['SOLUSDT'];
  var ltcData = cryptoData['LTCUSDT'];

  // Print the data to verify
  print('BTCUSDT Data: $btcData');
  print('ETHUSDT Data: $ethData');
  print('SOLUSDT Data: $solData');
  print('LTCUSDT Data: $ltcData');
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SingleChildScrollView( scrollDirection: Axis.vertical,
  child: Column(
    children: [
      FutureBuilder( future: fetchCryptoPrices(), builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
          child: LinearProgressIndicator(),
          );
        }
        else if (snapshot.hasError){
         return Center(child: Text('Error: ${snapshot.error}'));
        }
        double worth = 1.1459;
        final prices = snapshot.data!;
        final networth =  double.parse(prices[0]['price'])  * worth;
      
      return Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox( height: 40),
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
            SizedBox( width: 10,),
              Text('Labisi Buggies')
                ],
              ),
            const Spacer(),
              Padding(
              padding:  const EdgeInsets.only( right: 10),
              child: CircleAvatar( child: IconButton(onPressed: (){
                displayCryptoData();
              }, icon:  const Icon(Icons.notifications),)),
            ),  
            ],
            ),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Material( elevation: 20, shadowColor: Colors.black45,
            child: Container( decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
              Colors.black45, Colors.white70
              ]),
            borderRadius: BorderRadius.circular(10)        ),
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding:  EdgeInsets.only( left:15, top: 30),
                      child:  Text('Available Balance', style: StyleText.largeBodyText),
                    ),
              
            
               Padding(
                 padding: const EdgeInsets.only(left: 15),
                 child: Row(
                   children:  [
                  Text(worth.toString(), style: StyleText.priceText),
                 const SizedBox( width: 20,),
                 Padding(
                   padding:  const EdgeInsets.only(top: 7),
                   child: SizedBox( height: 25,
                  child:  Container( width: 50, decoration:  BoxDecoration( color: Palette.chipColor,
                 borderRadius: BorderRadius.circular(6)),
                    child: const Center(child:  Text('BTC', style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16
                    ),
                    )
                    ),
                    )
                   ),
                 ),
                 const Spacer(),
            const Padding(
               padding: EdgeInsets.only( right: 10),
               child: Icon(Icons.refresh),
             )       ],
                   ),
               ),
             Padding(
              padding:  const EdgeInsets.only(left: 15),
              child:  Text('${networth.toStringAsFixed(2)} USD', style: StyleText.largeBodyText,),
            ),
            const SizedBox(height: 30,),
              Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              chipFunc(Image.asset('assets/images/bitcoin.png', fit: BoxFit.contain, width: 40,), 'Send'),
              chipFunc(Image.asset('assets/images/bitcoin.png', fit: BoxFit.contain, width: 40,), 'Withdraw'),
              chipFunc( const Icon(Icons.add_circle_outline, size: 40,), 'More'),
              chipFunc( const Icon(Icons.grid_view, size: 40,), 'Buy'),
              ],
            )])
            ),
          ),
        ),
        const SizedBox( height: 30,),
        
        const Padding(
          padding:  EdgeInsets.all(8.0),
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Text('PORTFOLIO', style: StyleText.largeBodyText,),
          Row(
            children: [
              Text('24h'),
              Icon(Icons.swap_vert)
            ],
          )
            ],
          ),
        ),
        Flexible( 
          child: ListView.builder( itemCount: prices.length, shrinkWrap: true, scrollDirection: Axis.vertical,
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
                'image' : 'assets/images/litecoin.png'
              },
              {
                'coinName' : 'Solana', 
                'color' : Palette.solColor,
               'image' : 'assets/images/sol.png'

              },

            ];
            final price = prices[index];
            final symbol = price['symbol'];
            final displaySymbol = symbol.substring(0, 3);
          return portfolio(displaySymbol, price['price'], coins[index]['coinName'], displaySymbol == 'BTC'?
          worth.toString(): '0', coins[index]['image'] as String, coins[index]['color']);
          }),
        )
        ],
        );
      }),
    ],
  )
),
    );
  }

  Padding portfolio(String text, String price, String coinName, String asset, String img, Color color) {
    return Padding(
padding: const EdgeInsets.all(8.0),
child: GestureDetector( onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context){
  return const CryptoInfo();
})),
  child: Container(  width: double.infinity, height: 100,
  decoration: BoxDecoration( borderRadius: BorderRadius.circular(10), color: color),
    child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
   Padding(
     padding: const EdgeInsets.only( top: 10, bottom: 10, left: 10 ),
     child: Container( width: 80, 
  decoration: BoxDecoration( borderRadius: BorderRadius.circular(15),  color: Colors.white,),
      child:  Center(child:  Image.asset(img, width: 30, fit: BoxFit.contain,)),
     ),
   ),
 Padding(
  padding:  const EdgeInsets.only(top: 17),
  child:  Column(
    children: [
      Text(text, style: const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 25, color: Colors.orange
      ),),
 Text(coinName, style: const TextStyle(color: Colors.black45, fontSize: 15),)  ],
  ),
  ) ,
  lineChart(),
   Padding(
  padding: const EdgeInsets.only(right: 12, top: 25),
  child: Column(
    children: [
      Text('\$$price USD', style: StyleText.largeBodyTextBold,),
     Text('$asset $text', style: StyleText.largeBodyText,)
    ],
    
  ),
  )
  ],
    ),
  ),
),
);
  }
Widget lineChart() {
    return SizedBox( width: 60, height: 70,
child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData( color: Colors.orange,
                          spots: [
                             const FlSpot(0, 1),  // Add more data points for smoother curves
        const FlSpot(1, 2.5),
        const FlSpot(2, 2),
        const FlSpot(3, 3.5),
        const FlSpot(4, 2.8),
        const FlSpot(5, 4),
        const FlSpot(6, 3.2),
        const FlSpot(7, 3.2),
        const FlSpot(8, 3.2),
        const FlSpot(9, 3.2),
          const FlSpot(10, 1.5),
          const FlSpot(11, 2.1),
          const FlSpot(13, 2.5),                 
          const FlSpot(14, 2),                 
          const FlSpot(15, 2.1),                 
          const FlSpot(16, 5),                 
                          ],
                          
                          isCurved: true,   isStrokeCapRound: true, 
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            cutOffY: 1.3, applyCutOffY: true,
                            show: true,
                            gradient: LinearGradient( begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0,5],
                              colors: [
Colors.orange.withOpacity(1), Palette.chipColor.withOpacity(0.02)
                            ])
                           
                          ),
                        ),
                      ],
                    ),
                  ),
);
  }

Widget chipFunc(Widget img, String text) {
    return Column(
  children: [
    CircleAvatar( radius: 35, backgroundColor: Palette.fadedWhiteColor,
    child: img
    ),
 Text( text, style: StyleText.largeBodyText,) ],
);
  }
}