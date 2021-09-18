class Analysis {
  final double positives;
  final double neutrals;
  final double negatives;
  final double averageLikes;
  final double averageRetweets;

  Analysis({
    required this.positives,
    required this.neutrals,
    required this.negatives,
    required this.averageLikes,
    required this.averageRetweets,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      positives: json['positives'],
      neutrals: json['neutrals'],
      negatives: json['negatives'],
      averageLikes: json['averageLikes'],
      averageRetweets: json['averageRetweets'],
    );
  }
}
