class Images {
  final int image_id;
  final int result_id;

  final String image_status;
  final String image_name;
  final String image_url;
  final double image_lenght;
  final double image_width;
  final double image_weight;
  final double flaws_percent;
  final double brown_spot;
  final String color;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const Images({
    required this.image_id,
    required this.result_id,
    required this.image_status,
    required this.image_name,
    required this.image_url,
    required this.image_lenght,
    required this.image_width,
    required this.image_weight,
    required this.flaws_percent,
    required this.brown_spot,
    required this.color,
    required this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Images.fromSqfliteDatabase(Map<String, dynamic> map) => Images(
        image_id: map['image_id']?.toInt() ?? 0,
        result_id: map['result_id']?.toInt() ?? 0,
        image_status: map['img_status'] ?? '',
        image_name: map['image_name'] ?? '',
        image_url: map['image_url'] ?? '',
        image_lenght: map['mango_length']?.toDouble() ?? 0,
        image_width: map['mango_width']?.toDouble() ?? 0,
        image_weight: map['mango_weight']?.toDouble() ?? 0,
        flaws_percent: map['flaws_percent']?.toDouble() ?? 0,
        brown_spot: map['brown_spot']?.toDouble() ?? 0,
        color: map['color'] ?? '',
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
