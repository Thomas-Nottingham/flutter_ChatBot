import 'package:flutter/material.dart';
import 'package:flutter_chatbot/home_page.dart';
import 'package:flutter_chatbot/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'General Sand',
      theme: ThemeData.dark(useMaterial3:true).copyWith(
        //scaffoldBackgroundColor: Pallete.whiteColor,
// Optional: Set font weight
        appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
            color: Pallete.whiteColor, // Set the title color here
            fontSize: 25, // Optional: Set font size
            fontWeight: FontWeight.bold, ))
      ),
      home: const HomePage(),
    );
  }
}


