import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/signup_screen.dart';
import 'package:chat_app/screens/chat/chat_main_screen.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/screens/home/home_screen.dart';
import 'package:chat_app/shared/constants/navigation/navigator_key.dart';
import 'package:chat_app/shared/constants/navigation/screen_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const LoginScreen(),
        ),
        //  builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const SignUpScreen(),
        ),
        //  builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const HomeScreen(),
        ),
        //  builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'chat',
        path: '/chat',
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            const ChatScreen(),
          );
        },
      ),
      GoRoute(
          name: 'chat_main',
          path: '/chat_main',
          onExit: (ctx, state) {
            return true;
          },
          pageBuilder: (context, state) {
            ChatMainScreenArgs params = state.extra as ChatMainScreenArgs;
            return _buildPageWithTransition(
                ChatMainScreen(params: ChatMainScreenArgs(id: params.id)));
          },
          builder: (context, state) {
            ChatMainScreenArgs params = state.extra as ChatMainScreenArgs;

            return ChatMainScreen(
              params: ChatMainScreenArgs(id: params.id),
            );
          },
          redirect: (context, state) {
            final isLoggedIn = FirebaseAuth.instance.currentUser != null;
            if (!isLoggedIn) {
              return '/login';
            }
            return '/chat_main';
          }),
    ],
  );

  // Method to build pages with a fade transition
  static Page _buildPageWithTransition(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
