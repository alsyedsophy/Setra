import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/exceptions_mapper.dart';
import 'package:setra/features/home/data/models/banner_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore _firestore;

  HomeRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot = await _firestore
          .collection('banners')
          .orderBy('displayOrder')
          .get();
      return snapshot.docs
          .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw ExceptionsMapper.handleFirebaseFirestoreException(e);
    }
  }
}
