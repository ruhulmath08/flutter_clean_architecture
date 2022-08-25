import 'package:flutter_clean_architecture/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userName,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    super.address,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'image': image,
    };
  }
}
