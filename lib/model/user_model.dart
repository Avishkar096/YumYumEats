import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String? id;

  UserModel({
    required this.email,
    required this.name,
    required this.password,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      password: map['password'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
