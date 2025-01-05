import 'package:flutter/material.dart';

class Palette{
  // Colors
static const whiteColor = Colors.white;
static const blackColor = Color(0xFF16181C);
static const greenColor = Color(0xFF00EA48);
static const ethColor = Color(0xFFF9FAFF);
static const ltcColor = Color(0xFFF2F7FB);
static const solColor = Color(0xFFEBEFF2);
static const pureBlackColor = Colors.black;
static const fadedWhiteColor = Colors.black12;
static const chipColor =  Color.fromARGB(255, 252, 237, 215);

// Dark Theme
static var darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: blackColor,
  primaryColor: whiteColor,
  appBarTheme:const AppBarTheme(
    backgroundColor: blackColor
  ),
  iconTheme: const IconThemeData(
  color: whiteColor
  ),
  bottomAppBarTheme:const BottomAppBarTheme(
  color: pureBlackColor, 
  shadowColor: fadedWhiteColor
  )
);

// Light Theme
static var lighTheme = ThemeData.light().copyWith(
 scaffoldBackgroundColor: whiteColor,
 primaryColor: blackColor,
 appBarTheme:  const AppBarTheme(
  backgroundColor: whiteColor
 ),
 iconTheme:  const IconThemeData(
  color: blackColor
 ),
 bottomAppBarTheme: const BottomAppBarTheme(
color: whiteColor,
shadowColor: blackColor
 ),
);
}

class StyleText {
  static  const largeBodyText = TextStyle(
  fontSize: 18, color: Colors.black45
  );

static const priceText = TextStyle(
fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold
);
static const largeBodyTextBold = TextStyle(
   fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold
);
}