import 'package:equatable/equatable.dart';

enum ProductSortOption {
  newest('sortNewest'),
  priceLowToHigh('sortPriceLowToHigh'),
  priceHighToLow('sortPriceHighToLow'),
  highestRated('sortHighestRated'),
  mostReviewed('sortMostReviewed'),
  bestDiscount('sortBestDiscount'),
  featured('sortFeatured'),
  nameAsc('sortNameAsc'),
  nameDesc('sortNameDesc');

  const ProductSortOption(this.localizationKey);
  final String localizationKey;

  bool get isDescending {
    switch (this) {
      case ProductSortOption.newest:
      case ProductSortOption.priceHighToLow:
      case ProductSortOption.highestRated:
      case ProductSortOption.mostReviewed:
      case ProductSortOption.bestDiscount:
      case ProductSortOption.featured:
      case ProductSortOption.nameDesc:
        return true;
      case ProductSortOption.priceLowToHigh:
      case ProductSortOption.nameAsc:
        return false;
    }
  }

  /// حقل Firestore المرتبط بالترتيب
  String get firestoreField {
    switch (this) {
      case ProductSortOption.newest:
        return 'createdAt';
      case ProductSortOption.priceLowToHigh:
      case ProductSortOption.priceHighToLow:
        return 'price';
      case ProductSortOption.highestRated:
        return 'rating';
      case ProductSortOption.mostReviewed:
        return 'reviewCount';
      case ProductSortOption.bestDiscount:
        return 'discountPrice';
      case ProductSortOption.featured:
        return 'featured';
      case ProductSortOption.nameAsc:
      case ProductSortOption.nameDesc:
        return 'name';
    }
  }
}

class ProductSort extends Equatable {
  final ProductSortOption option;

  const ProductSort({this.option = ProductSortOption.newest});

  ProductSort copyWith({ProductSortOption? option}) =>
      ProductSort(option: option ?? this.option);

  @override
  List<Object?> get props => [option];
}
