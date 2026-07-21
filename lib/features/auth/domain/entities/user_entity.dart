import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    this.email,
    this.isEmailVerified = false,
  });

  final String id;
  final String name;
  final String? email;
  final bool isEmailVerified;

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
  }) => UserEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
  );

  @override
  List<Object?> get props => [id, name, email, isEmailVerified];
}
