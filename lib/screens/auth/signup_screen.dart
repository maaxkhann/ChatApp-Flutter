import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/components/primary_button.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/shared/constants/navigation/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          backgroundColor: Colors.grey, automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Register',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: nameController,
              hintText: 'Enter Name',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: emailController,
              hintText: 'Enter Email',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              hintText: 'Enter Password',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
            ),
            const SizedBox(height: 30),
            PrimaryButton(
                text: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  authController.registerUser(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      confirmPasswordController.text.trim());
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.loginView),
                    child: const Text('Login',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
