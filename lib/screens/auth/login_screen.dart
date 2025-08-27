// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IntroductionScreen(
//         scrollPhysics: const ClampingScrollPhysics(),
//         animationDuration: 500,
//         pages: [
//           PageViewModel(
//             title: "Read your e-books",
//             body:
//                 "You can buy any book online, we will deliver within two days in Uzbakistan",
//             image: Image.asset(
//               'assets/book.png',
//               height: 170,
//             ),
//             decoration: const PageDecoration(
//               imagePadding: EdgeInsets.all(0),
//               titlePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//               bodyPadding: EdgeInsets.only(top: 12, left: 12, right: 8),
//               pageMargin: EdgeInsets.only(bottom: 80),
//               imageFlex: 2,
//               titleTextStyle:
//                   TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               bodyTextStyle: TextStyle(fontSize: 15.0),
//             ),
//           ),
//           PageViewModel(
//             title: "Order your books",
//             body:
//                 "You can buy any book online, we will deliver within two days in Uzbakistan",
//             image: Image.asset('assets/book.png', height: 170.0),
//             decoration: const PageDecoration(
//               imagePadding: EdgeInsets.all(0),
//               titlePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//               bodyPadding: EdgeInsets.only(top: 12, left: 12, right: 8),
//               pageMargin: EdgeInsets.only(bottom: 80),
//               imageFlex: 2,
//               titleTextStyle:
//                   TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               bodyTextStyle: TextStyle(fontSize: 15.0),
//             ),
//           ),
//           PageViewModel(
//             title: "Now you can listen audio books",
//             body:
//                 "You can buy any book online, we will deliver within two days in Uzbakistan",
//             image: Image.asset(
//               'assets/book.png',
//               height: 170,
//             ),
//             decoration: const PageDecoration(
//               imagePadding: EdgeInsets.all(0),
//               titlePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//               bodyPadding: EdgeInsets.only(top: 12, left: 12, right: 8),
//               pageMargin: EdgeInsets.only(bottom: 80),
//               imageFlex: 2,
//               titleTextStyle:
//                   TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               bodyTextStyle: TextStyle(fontSize: 15.0),
//             ),
//           ),
//         ],
//         onDone: () {
//           //    When done button is pressed, navigate to home screen
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (_) => HomeScreen()),
//           );
//         },
//         onSkip: () {
//           // Skip the intro and go to home screen
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (_) => HomeScreen()),
//           );
//         },
//         showSkipButton: true,
//         skip: const Text('Skip'),
//         next: Container(
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 22),
//             decoration: BoxDecoration(
//                 color: const Color(0xFF42BEFA),
//                 borderRadius: BorderRadius.circular(20)),
//             child: const Text(
//               'Next',
//               style: TextStyle(color: Colors.white),
//             )),
//         done: Container(
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 22),
//             decoration: BoxDecoration(
//                 color: const Color(0xFF42BEFA),
//                 borderRadius: BorderRadius.circular(20)),
//             child: const Text(
//               'Done',
//               style: TextStyle(color: Colors.white),
//             )),
//         dotsDecorator: DotsDecorator(
//           size: const Size(22.0, 8),
//           activeSize: const Size(22.0, 8.0),
//           activeColor: Colors.grey,
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(color: Colors.grey),
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//           activeShape: RoundedRectangleBorder(
//             side: const BorderSide(color: Colors.grey),
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//       ),
//       body: Center(
//         child: Text("Welcome to the Home Screen!"),
//       ),
//     );
//   }
// }

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.put(AuthController());
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
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            const SizedBox(height: 30),
            PrimaryButton(
                text: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  authController.loginUser(emailController.text.trim(),
                      passwordController.text.trim());
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.registerView),
                    //       onPressed: () => context.push('/register'),
                    child: const Text('Sign Up',
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
