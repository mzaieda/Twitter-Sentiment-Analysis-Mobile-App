import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/screens/analysis_page.dart';
import 'package:mobile/services/api.dart';

class LoadingPage extends StatefulWidget {
  final String text;
  const LoadingPage(this.text, {Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _error = false;

  Future<void> init() async {
    fetchApi(widget.text).then(
      (analysis) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisPage(analysis),
          ),
        );
      },
    ).onError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _error = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _error ? Colors.red : Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _error
              ? const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50,
                  ),
                )
              : const SpinKitRotatingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _error ? "Error during the analysis." : "Analysing the tweets...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          _error ? const BackButton(color: Colors.white) : Container(),
        ],
      ),
    );
  }
}
