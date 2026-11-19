import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/exceptions_mapper.dart';
import 'package:setra/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<void> createProfile(ProfileModel profile);

  Future<ProfileModel> ensureProfile(ProfileModel profile);

  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  static const String _collection = 'users';

  ProfileRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String get _uid {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      log(
        '------------- user == null in profile data source ------------------',
      );
      throw AuthException(message: 'User must be authenticated.');
    }

    return user.uid;
  }

  // الحصول على مرجع ملف المستخدم
  DocumentReference<Map<String, dynamic>> _userReference(String userId) {
    return _firestore.collection(_collection).doc(userId);
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final snapshot = await _userReference(_uid).get();

      if (!snapshot.exists || snapshot.data() == null) {
        throw ServerException(message: 'Profile not found');
      }

      return ProfileModel.fromFirestore(snapshot.data()!, snapshot.id);
    } catch (e) {
      throw ExceptionsMapper.handleUnknowException(e);
    }
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    try {
      final reference = _userReference(profile.id);

      await _firestore.runTransaction((transaction) async {
        log('---------------- run transaction ----------------');
        final snapshot = await transaction.get(reference);
        log('---------------- get snapshot ----------------');

        if (snapshot.exists) {
          log(
            '---------------- snaphot exists = ${snapshot.exists} ----------------',
          );
          throw ServerException(message: 'User profile already exists');
        }

        transaction.set(reference, profile.toFirestore());
        log('---------------- set profile success ----------------');
      });
    } catch (e) {
      log('---------------- create profile error $e ----------------');
      throw ExceptionsMapper.handleUnknowException(e);
    }
  }

  @override
  Future<ProfileModel> ensureProfile(ProfileModel profile) async {
    try {
      final reference = _userReference(profile.id);

      return await _firestore.runTransaction<ProfileModel>((transaction) async {
        final snapshot = await transaction.get(reference);

        // الملف موجود بالفعل، لا نغير بياناته.
        if (snapshot.exists && snapshot.data() != null) {
          return ProfileModel.fromFirestore(snapshot.data()!, snapshot.id);
        }

        // الملف غير موجود، ننشئه.
        transaction.set(reference, profile.toFirestore());

        return profile;
      });
    } catch (e) {
      throw ExceptionsMapper.handleUnknowException(e);
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final reference = _userReference(profile.id);

      final snapshot = await reference.get();

      if (!snapshot.exists) {
        throw ServerException(message: 'Profile not found');
      }

      await reference.update(profile.toUpdateFirestore());

      return ProfileModel.fromEntity(
        profile.copyWith(updatedAt: DateTime.now()),
      );
    } catch (e) {
      throw ExceptionsMapper.handleUnknowException(e);
    }
  }
}
