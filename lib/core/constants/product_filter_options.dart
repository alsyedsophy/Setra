class ProductFilterOptions {
  ProductFilterOptions._();

  // ============ Sizes ============
  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  // ============ Colors ============
  static const List<String> colors = [
    'Black',
    'White',
    'Grey',
    'Navy',
    'Red',
    'Green',
    'Blue',
    'Beige',
  ];

  // ============ Tags ============
  static const List<String> tags = [
    'winter',
    'summer',
    'cotton',
    'oversized',
    'graphic',
    'plain',
    'zip',
    'hooded',
  ];

  // ============ Price Range Bounds ============
  static const double minPrice = 0;
  static const double maxPrice = 2000;
  static const int priceDivisions = 20; // للـ RangeSlider
}
