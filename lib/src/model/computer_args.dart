class ComputerArgs {
  final String cert;
  final String encoded;

  const ComputerArgs({
    required this.cert,
    required this.encoded,
  });

  factory ComputerArgs.fromJson(Map<String, dynamic> json) {
    return ComputerArgs(
      cert: json['cert'] as String,
      encoded: json['encoded'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cert': cert,
      'encoded': encoded,
    };
  }
}
