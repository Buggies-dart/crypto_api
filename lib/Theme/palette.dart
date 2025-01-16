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
static const fadedWhiteColor = Colors.black45;
static const chipColor =  Color.fromARGB(255, 252, 237, 215);


// Dark Theme
static var darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: blackColor,
  primaryColor: whiteColor,
   textTheme: const TextTheme(
 displayLarge: StyleText.largeBodyTextBoldwhite,
 titleLarge: StyleText.priceTextwhite,
   bodyMedium: StyleText.largeBodyTextwhite

  ),
  colorScheme: const ColorScheme.dark(
    primary: whiteColor, 
    primaryContainer: greenColor,
    secondaryContainer: Color.fromARGB(255, 157, 248, 184),
    onPrimary: blackColor, 
    surface: blackColor, 
    onSurface: whiteColor, 
  ),
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

  textTheme: const TextTheme(
 displayLarge: StyleText.largeBodyTextBoldblack,
  titleLarge: StyleText.priceTextblack,
  bodyMedium: StyleText.largeBodyText

  ),
  colorScheme: const ColorScheme.light(
    primary: blackColor, // App's primary color
    onPrimary: whiteColor, // Text/icon color on primary
    surface: whiteColor, // Surface color (e.g., cards, modals)
    onSurface: blackColor, // Text/icon color on surface
    primaryContainer: fadedWhiteColor,
    secondaryContainer: Colors.white70,
  ),
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
  static  const largeBodyTextwhite = TextStyle(
  fontSize: 18, color: Colors.white
  );

static const priceTextblack = TextStyle(
fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold
);
static const priceTextwhite = TextStyle(
fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold
);
static const largeBodyTextBoldwhite = TextStyle(
   fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold
);
static const largeBodyTextBoldblack = TextStyle(
   fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold
);
}