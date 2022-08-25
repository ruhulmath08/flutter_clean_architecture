import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.address,
    this.image,
  });

  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? image;

  @override
  List<Object?> get props => [
        userName,
        fullName,
        email,
        phoneNumber,
        address,
        image,
      ];
}
