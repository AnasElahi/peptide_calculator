import 'package:flutter/material.dart';

class ScalePainter extends CustomPainter {
  final double syringeUnits; // Calculated syringe units
  final double scalingFactor; // Total scale units based on syringe volume (e.g., 30, 50, 100)

  ScalePainter({required this.syringeUnits, required this.scalingFactor});

  @override
  void paint(Canvas canvas, Size size) {
    // Define padding for the scale
    double padding = 22.5;

    // Start and end positions for the scale
    double startX = padding;
    double endX = size.width - padding;

    // Paint for the main scale line
    Paint scalePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Paint for the highlighted section (up to syringeUnits)
    Paint highlightPaint = Paint()
      ..color = Colors.pink.withOpacity(0.5) // Semi-transparent pink
      ..strokeWidth = 35.0;

    // Draw the main scale line
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(endX, size.height / 2),
      scalePaint,
    );

    // Calculate the width per unit
    double unitWidth = (endX - startX) / scalingFactor;

    // Highlight the section up to the syringeUnits
    double highlightEndX = startX + (syringeUnits / scalingFactor) * (endX - startX);
    if (highlightEndX > endX) {
      highlightEndX = endX ;
    }
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(highlightEndX, size.height / 2),
      highlightPaint,
    );

    // Draw the ticks and labels
    for (int i = 0; i <= scalingFactor.toInt(); i++) {
      double x = startX + i * unitWidth;

      // Draw longer ticks for every 10 units
      double tickHeight = i % 10 == 0 ? 15 : 8;
      canvas.drawLine(
        Offset(x, size.height / 2 - tickHeight),
        Offset(x, size.height / 2 + tickHeight),
        scalePaint,
      );

      // Draw labels for every 10 units
      if (i % 10 == 0) {
        // Change color based on the desired dosage
        Color labelColor = (i <= syringeUnits) ? Colors.pink : Colors.black;

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '$i', // Display unit labels
            style: TextStyle(color: labelColor, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height / 2 + 20));
      }
    }

    // Draw the syringeUnits text above the highlighted area
    // TextPainter unitTextPainter = TextPainter(
    //   text: TextSpan(
    //     text: '${syringeUnits.toStringAsFixed(1)} units',
    //     style: const TextStyle(color: Colors.pink, fontSize: 12, fontWeight: FontWeight.bold),
    //   ),
    //   textDirection: TextDirection.ltr,
    // );
    // unitTextPainter.layout();
    // unitTextPainter.paint(
    //     canvas, Offset(highlightEndX - unitTextPainter.width / 2, size.height / 2 - 40));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for dynamic updates
  }
}
