import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? name;
  final String? email;
  final String? image;
  final Timestamp? lastSeen;
  final String? fcmToken;
  final bool? isOnline;
  final Timestamp? createdAt;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.image,
    this.lastSeen,
    this.fcmToken,
    this.isOnline,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      lastSeen: data['lastSeen'] ?? Timestamp.now(),
      fcmToken: data['fcmToken'] ?? '',
      isOnline: data['isOnline'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
      'lastSeen': lastSeen,
      'fcmToken': fcmToken,
      'isOnline': isOnline,
      'createdAt': createdAt,
    };
  }
}
