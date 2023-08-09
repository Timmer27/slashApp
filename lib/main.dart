import 'package:flutter/material.dart';
import 'package:slash/mainPage/mainPage.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (context) {
      return MaterialApp(
        title: '위튼버그',
        // debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Color.fromARGB(255, 247, 247, 247),
            // primarySwatch: Colors.blueGrey,
            primaryColor: Color.fromARGB(255, 5, 30, 41)),
        home: const MainPage(title: 'WITTENBURG ENGLISH TRAINING PROGRAM'),
      );
    });
  }
}
