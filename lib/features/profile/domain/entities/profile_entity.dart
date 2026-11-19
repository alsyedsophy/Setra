import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProfileEntity.empty() {
    return ProfileEntity(
      id: '',
      name: '',
      email: null,
      phoneNumber: null,
      photoUrl: null,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phoneNumber,
    photoUrl,
    createdAt,
    updatedAt,
  ];
}
