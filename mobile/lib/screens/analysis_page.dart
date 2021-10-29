import 'package:flutter/material.dart';
import 'package:mobile/models/analysis.dart';
import 'package:mobile/models/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisPage extends StatefulWidget {
  final String title;
  final Analysis analysis;

  const AnalysisPage({
    required this.title,
    required this.analysis,
    Key? key,
  }) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final List<ChartData> _data = [];
  String _sentiment = "";
  Color _color = Colors.grey;

  @override
  void initState() {
    super.initState();
    _data.add(ChartData.fromPositives(widget.analysis.positives));
    _data.add(ChartData.fromNeutrals(widget.analysis.neutrals));
    _data.add(ChartData.fromNegatives(widget.analysis.negatives));
    _setSentiment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Average Likes: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  widget.analysis.averageLikes.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Average Retweets: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  widget.analysis.averageRetweets.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Column(
              children: <Widget>[
                const Text(
                  "The overall sentiment is ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  _sentiment,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _color,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.right,
                  toggleSeriesVisibility: true,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: _data,
                    pointColorMapper: (ChartData chartData, _) =>
                        chartData.color,
                    xValueMapper: (ChartData chartData, _) => chartData.x,
                    yValueMapper: (ChartData chartData, _) => chartData.y,
                    dataLabelMapper: (ChartData chartData, _) =>
                        chartData.label,
                    radius: '80%',
                    explode: true,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      color: Colors.white,
                      useSeriesColor: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setSentiment() {
    double difference = widget.analysis.positives - widget.analysis.negatives;
    if (difference <= -0.5) {
      _sentiment = "Very Negative";
      _color = Colors.red[700]!;
    } else if (difference <= -0.3) {
      _sentiment = "Negative";
      _color = Colors.red;
    } else if (difference <= -0.1) {
      _sentiment = "Slightly Negative";
      _color = Colors.red[300]!;
    } else if (difference < 0.1) {
      _sentiment = "Neutral";
      _color = Colors.grey;
    } else if (difference < 0.3) {
      _sentiment = "Slightly Positive";
      _color = Colors.green[200]!;
    } else if (difference < 0.5) {
      _sentiment = "Positive";
      _color = Colors.green;
    } else {
      _sentiment = "Very Positive";
      _color = Colors.green[700]!;
    }
  }
}
