class Category {
  String thumbnail;
  String name;

  Category({
    required this.name,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'คลังความรู้',
    thumbnail: 'assets/images/icons8-book-shelf-64.png',
  ),
  Category(
    name: 'ตลาดกลาง',
    thumbnail: 'assets/images/icons8-market-64.png',
  ),
  Category(
    name: 'คอลเลคชัน',
    thumbnail: 'assets/images/icons8-image-gallery-64.png',
  ),
  Category(
    name: 'ประวัติการ\nวิเคราะห์',
    thumbnail: 'assets/images/icons8-history-64.png',
  ),
];
