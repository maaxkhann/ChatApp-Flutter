import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/exceptions/firebase_exceptions.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        UserModel? userModel = UserModel(
            userId: userCredential.user!.uid,
            name: name,
            email: email,
            image: '',
            lastSeen: Timestamp.now(),
            fcmToken: '',
            isOnline: true,
            createdAt: Timestamp.now());
        DocumentReference docRef =
            firestore.collection('Users').doc(userCredential.user!.uid);
        await docRef.set(
          userModel.toMap(),
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw UnknownException('Unexpected error occurred.');
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Get.toNamed(AppRoutes.homeView);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw UnknownException('Unexpected error occurred.');
    }
  }
}
