import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String profilePicture;

  const User({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [id, name, profilePicture];

  User copyWith({
    int? id,
    String? name,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
