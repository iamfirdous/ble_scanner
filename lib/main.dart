import 'package:bt_scanner/constants.dart';
import 'package:bt_scanner/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextStyle button = TextStyle(
    fontSize: 24.0,
    color: const Color(0xFF3BABFE),
    fontFamily: Fonts.fredoka,
    letterSpacing: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Texts.app_name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: Fonts.open_sans,
        textTheme: TextTheme(
          button: button,
          bodyText1: button.copyWith(color: Colors.white),
          bodyText2: button.copyWith(color: const Color(0xFF656666)),
          subtitle1: button.copyWith(color: const Color(0xFF656666), fontSize: 18.0),
          subtitle2: button.copyWith(
            color: const Color(0xFF656666),
            fontSize: 18.0,
            fontFamily: Fonts.open_sans,
          ),
        ),
      ),
      home: MainPage(),
    );
  }
}
