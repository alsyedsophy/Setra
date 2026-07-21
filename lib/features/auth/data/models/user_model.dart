import 'package:setra/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    super.email,
    super.isEmailVerified,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      isEmailVerified: data['isEmailVerified'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'name': name,
    'email': email,
    'isEmailVerified': isEmailVerified,
  };

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      isEmailVerified: entity.isEmailVerified,
    );
  }
}
