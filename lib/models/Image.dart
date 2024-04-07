class Image {
  final int image_id;
  final int result_id;

  final String image_status;
  final String image_name;
  final String image_url;
  final int image_lenght;
  final int image_width;
  final int image_weight;
  final int flaws_percent;
  final int brown_spot;
  final String color;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const Image({
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
}
