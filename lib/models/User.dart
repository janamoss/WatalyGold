class User {
  final int user_id;
  final String user_ipaddress;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const User({
    required this.user_id,
    required this.user_ipaddress,
    required this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory User.fromSqfliteDatabase(Map<String, dynamic> map) => User(
        user_id: map['user_id']?.toInt() ?? 0,
        user_ipaddress: map['user_ipaddress'] ?? '',
        created_at: DateTime.fromMicrosecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updated_at: map['updated_at'] != null
            ? (map['updated_at'] is int
                ? DateTime.fromMicrosecondsSinceEpoch(map['updated_at'])
                    .toIso8601String()
                : map['updated_at'] as String)
            : null,
      );
}
