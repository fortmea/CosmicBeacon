class Insight {
  String output;

  Insight({required this.output});

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      output: json['output'] ?? "",
    );
  }

  static empty() {
    return Insight(output: '');
  }
}
