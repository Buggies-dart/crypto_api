import 'package:crypto_app/Theme/palette.dart';
import 'package:crypto_app/Widgets/charts.dart';
import 'package:flutter/material.dart';

class CryptoInfo extends StatefulWidget {
  final String coinName;
  final String coinPrice;
  final String coinImg;
  final Color color;
  const CryptoInfo({super.key, required this.coinName, required this.coinPrice, required this.coinImg, required this.color});

  @override
  State<CryptoInfo> createState() => _CryptoInfoState();
}

class _CryptoInfoState extends State<CryptoInfo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(widget.coinName, style: StyleText.largeBodyTextBold),
                        const Text('-1.32%'),
                      ],
                    ),
                    const Icon(Icons.outbond_outlined),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                             Text(widget.coinPrice, style: StyleText.priceText),
                            const SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: SizedBox(
                                height: 25,
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Palette.chipColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+0.05 %',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'At Close December 31st 2024 - 11.59 PM',
                          style: TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: const BorderRadiusDirectional.horizontal(
                          start: Radius.circular(10),
                          end: Radius.circular(10),
                        ),
                      ),
                      child: Image.asset(widget.coinImg, fit: BoxFit.contain, width: 25,),
                    ),
                  ),
                ],
              ),
            const  SizedBox( height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TabBar(
                  indicatorColor: Colors.black,
                  dividerHeight: 0,
                  indicatorWeight: 0.5,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black45,
                  tabs: [
                    Text('24H', style: StyleText.largeBodyText),
                    Text('1H', style: StyleText.largeBodyText),
                    Text('4H', style: StyleText.largeBodyText),
                    Text('1W', style: StyleText.largeBodyText),
                    Text('ALL', style: StyleText.largeBodyText),
                  ],
                ),
              ),
        const Flexible(
          child: CandlestickChart()) ],
         ),
        ),
      ),
    );
  }
}
