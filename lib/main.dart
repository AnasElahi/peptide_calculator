import 'package:flutter/material.dart';
import 'package:peptide_calculator/pages/peptide_calculator_page.dart';

void main() {
  runApp(const PeptideCalculatorApp());
}

class PeptideCalculatorApp extends StatelessWidget {  
  const PeptideCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peptide Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'P22_Mackinac_Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(227, 50, 121, 1.0),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Halyard_Display',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(84, 47, 47, 1.0),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1.0),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'P22_Mackinac_Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(236, 72, 153, 1.0),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Halyard_Display',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(189, 189, 189, 1.0),
          ),
        ),
      ),
      themeMode: ThemeMode.system, 
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   textTheme: const TextTheme(
      //     titleLarge: TextStyle(
      //       fontFamily: 'P22_Mackinac_Pro',
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //       color: Color.fromRGBO(227, 50, 121, 1.0),
      //     ),
      //     bodyLarge: TextStyle(
      //       fontFamily: 'Halyard_Display',
      //       fontSize: 18,
      //       fontWeight: FontWeight.normal,
      //       color: Color.fromRGBO(84, 47, 47, 1.0),
      //     ),
      //   ),
      // ),
      home: const PeptideCalculatorPage(),
    );
  }
}