import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/address/data/models/address_model.dart';

abstract class RemoteAddressDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getDefaultAddress();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

class RemoteAddressDataSourceImpl implements RemoteAddressDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RemoteAddressDataSourceImpl({required this.firestore, required this.auth});

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException(message: 'User must be authenticated');
    }
    return uid;
  }

  /// addresses subcollection تحت المستخدم
  CollectionReference<Map<String, dynamic>> get _addressesCol =>
      firestore.collection('users').doc(_uid).collection('addresses');

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final snapshot = await _addressesCol
          .orderBy('is_default', descending: true)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc.data(), id: doc.id))
          .toList();
    } on AuthException {
      rethrow;
    } catch (e) {
      log('getAddresses error: $e');
      throw ServerException(message: 'فشل جلب العناوين');
    }
  }

  @override
  Future<AddressModel?> getDefaultAddress() async {
    try {
      final snapshot = await _addressesCol
          .where('is_default', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return AddressModel.fromFirestore(doc.data(), id: doc.id);
    } on AuthException {
      rethrow;
    } catch (e) {
      log('getDefaultAddress error: $e');
      throw ServerException(message: 'فشل جلب العنوان الافتراضي');
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final uid = _uid;

      return await firestore.runTransaction((transaction) async {
        // لو ده أول عنوان أو isDefault = true → خليه افتراضي وشل الافتراضي من الباقي
        final existing = await _addressesCol.get();
        final shouldBeDefault = address.isDefault || existing.docs.isEmpty;

        if (shouldBeDefault) {
          for (final doc in existing.docs) {
            if (doc.data()['is_default'] == true) {
              transaction.update(doc.reference, {'is_default': false});
            }
          }
        }

        final docRef = _addressesCol.doc();
        final now = DateTime.now();
        final model = AddressModel(
          id: docRef.id,
          userId: uid,
          fullName: address.fullName.trim(),
          phone: address.phone.trim(),
          city: address.city.trim(),
          area: address.area.trim(),
          street: address.street.trim(),
          building: address.building?.trim(),
          notes: address.notes?.trim(),
          isDefault: shouldBeDefault,
          createdAt: now,
          updatedAt: now,
        );

        transaction.set(docRef, model.toFirestore());
        return model;
      });
    } on AuthException {
      rethrow;
    } catch (e) {
      log('addAddress error: $e');
      throw ServerException(message: 'فشل إضافة العنوان');
    }
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      final docRef = _addressesCol.doc(address.id);

      return await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw ServerException(message: 'العنوان غير موجود');
        }

        if (address.isDefault) {
          final existing = await _addressesCol.get();
          for (final doc in existing.docs) {
            if (doc.id != address.id && doc.data()['is_default'] == true) {
              transaction.update(doc.reference, {'is_default': false});
            }
          }
        }

        final now = DateTime.now();
        final updated = AddressModel(
          id: address.id,
          userId: _uid,
          fullName: address.fullName.trim(),
          phone: address.phone.trim(),
          city: address.city.trim(),
          area: address.area.trim(),
          street: address.street.trim(),
          building: address.building?.trim(),
          notes: address.notes?.trim(),
          isDefault: address.isDefault,
          createdAt: AddressModel.fromFirestore(
            snapshot.data()!,
            id: address.id,
          ).createdAt,
          updatedAt: now,
        );

        transaction.update(docRef, updated.toFirestore());
        return updated;
      });
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      log('updateAddress error: $e');
      throw ServerException(message: 'فشل تحديث العنوان');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      final docRef = _addressesCol.doc(addressId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw ServerException(message: 'العنوان غير موجود');
        }

        final wasDefault = snapshot.data()?['is_default'] as bool? ?? false;

        transaction.delete(docRef);

        // لو اتحذف الافتراضي → خلّي أول عنوان متبقي افتراضي
        if (wasDefault) {
          final remaining = await _addressesCol
              .orderBy('created_at', descending: true)
              .limit(1)
              .get();
          if (remaining.docs.isNotEmpty) {
            transaction.update(remaining.docs.first.reference, {
              'is_default': true,
            });
          }
        }
      });
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      log('deleteAddress error: $e');
      throw ServerException(message: 'فشل حذف العنوان');
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final docRef = _addressesCol.doc(addressId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw ServerException(message: 'العنوان غير موجود');
        }

        final existing = await _addressesCol.get();
        for (final doc in existing.docs) {
          final isTarget = doc.id == addressId;
          transaction.update(doc.reference, {'is_default': isTarget});
        }
      });
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      log('setDefaultAddress error: $e');
      throw ServerException(message: 'فشل تعيين العنوان الافتراضي');
    }
  }
}
