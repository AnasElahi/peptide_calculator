// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:peptide_calculator/main.dart';
import 'package:peptide_calculator/pages/peptide_calculator_page.dart';

void main() {
  testWidgets('Peptide Calculator App smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const PeptideCalculatorApp());

    // Verify that the app title is displayed.
    expect(find.text('Peptide Calculator'), findsOneWidget);

    // Verify that the initial page is the PeptideCalculatorPage.
    expect(find.byType(PeptideCalculatorPage), findsOneWidget);

    // Verify that the initial UI elements are present.
    expect(find.text('What is the total volume of your syringe?'), findsOneWidget);
    expect(find.text('What is the total quantity of peptide in the vial?'), findsOneWidget);
    expect(find.text('How much bacteriostatic water will be added?'), findsOneWidget);
    expect(find.text('What is the desired research dosage for the peptide?'), findsOneWidget);
  });
}


// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:peptide_calculator/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const PeptideCalculatorApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }