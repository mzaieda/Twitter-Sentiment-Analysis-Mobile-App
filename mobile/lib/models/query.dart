class Query {
  final String text;
  bool favorite;

  Query({required this.text, required this.favorite});

  factory Query.fromJson(Map<String, dynamic> json) =>
      Query(text: json['text'], favorite: json['favorite']);

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> json = {};
    json['text'] = text;
    json['favorite'] = favorite;
    return json;
  }
}
