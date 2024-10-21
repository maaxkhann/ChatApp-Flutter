import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/components/primary_button.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/shared/constants/navigation/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
                onPressed: () async {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                  if (userCredential.user != null) {
                    UserService.instance.storeUserData(
                        nameController.text, emailController.text);
                    EasyLoading.showToast('Account created');
                    //   Get.to(() => const LoginScreen());
                    Navigation.pushNamed('/login');
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextButton(
                    onPressed: () => Navigation.pushNamed('/login'),
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
