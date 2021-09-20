import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.x, this.y, this.label, this.color);
  final String x;
  final double y;
  final String label;
  final Color color;

  factory ChartData.fromPositives(double positives) {
    return ChartData(
      "Positives",
      positives,
      "${(positives * 100).toStringAsFixed(2)}%",
      Colors.green,
    );
  }

  factory ChartData.fromNeutrals(double neutrals) {
    return ChartData(
      "Neutrals",
      neutrals,
      "${(neutrals * 100).toStringAsFixed(2)}%",
      Colors.grey,
    );
  }

  factory ChartData.fromNegatives(double negatives) {
    return ChartData(
      "Negatives",
      negatives,
      "${(negatives * 100).toStringAsFixed(2)}%",
      Colors.red,
    );
  }
}
