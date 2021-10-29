import 'package:flutter/material.dart';

class ChartData {
  final String x;
  final double y;
  final String label;
  final Color color;

  ChartData({
    required this.x,
    required this.y,
    required this.label,
    required this.color,
  });

  factory ChartData.fromPositives(double positives) => ChartData(
        x: "Positives",
        y: positives,
        label: "${(positives * 100).toStringAsFixed(2)}%",
        color: Colors.green,
      );

  factory ChartData.fromNeutrals(double neutrals) => ChartData(
        x: "Neutrals",
        y: neutrals,
        label: "${(neutrals * 100).toStringAsFixed(2)}%",
        color: Colors.grey,
      );

  factory ChartData.fromNegatives(double negatives) => ChartData(
        x: "Negatives",
        y: negatives,
        label: "${(negatives * 100).toStringAsFixed(2)}%",
        color: Colors.red,
      );
}
