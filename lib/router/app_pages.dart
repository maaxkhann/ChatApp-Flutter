import 'package:chat_app/router/app_routes.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/signup_screen.dart';
import 'package:chat_app/screens/chat/chat_main_screen.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/screens/chat/create_group_screen.dart';
import 'package:chat_app/screens/home/home_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    // GetPage(
    //   name: AppRoutes.splashView,
    //   transition: Transition.rightToLeft,
    //   page: () => SplashView(),
    //   // binding: BindingsBuilder(() {
    //   //   Get.lazyPut<SplashViewModel>(() => SplashViewModel());
    //   //   // Get.lazyPut<SubsViewModel>(() => SubsViewModel());
    //   // }),
    // ),
    GetPage(
      name: AppRoutes.loginView,
      transition: Transition.rightToLeft,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.registerView,
      transition: Transition.rightToLeft,
      page: () => const SignUpScreen(),
    ),

    GetPage(
        name: AppRoutes.homeView,
        transition: Transition.fadeIn,
        page: () => const HomeScreen()),

    GetPage(
      name: AppRoutes.chatView,
      transition: Transition.fadeIn,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.chatMainView,
      transition: Transition.fadeIn,
      page: () => const ChatMainScreen(),
    ),
    GetPage(
      name: AppRoutes.createGroupView,
      transition: Transition.fadeIn,
      page: () => const CreateGroupScreen(),
    ),
  ];
}
