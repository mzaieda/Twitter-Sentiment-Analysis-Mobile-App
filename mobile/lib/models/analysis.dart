class Analysis {
  final double positives;
  final double negatives;

  Analysis({
    required this.positives,
    required this.negatives,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      positives: json['positives'],
      negatives: json['negatives'],
    );
  }
}
