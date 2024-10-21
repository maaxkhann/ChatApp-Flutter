import 'package:chat_app/shared/constants/navigation/navigator_key.dart';
import 'package:go_router/go_router.dart';

class Navigation {
  // Push route using GoRouter
  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return appContext.push(routeName, extra: arguments);
  }

  static Future<dynamic> pushNamedAuthorized(String routeName,
      {Object? arguments}) {
    // Example: Check user authorization before navigating
    // if (AppData.instance.user == null) {
    //   return GoRouter.of(appContext).push(AuthCommonScreen.routeName);
    // }
    return appContext.push(routeName, extra: arguments);
    // return GoRouter.of(appContext).push(routeName, extra: arguments);
  }

  // Replace current route using GoRouter
  static Future<dynamic> pushReplacementNamed(String routeName,
      {Object? arguments}) {
    return GoRouter.of(appContext).replace(routeName, extra: arguments);
  }

  // Remove all previous routes and navigate to a new one
  static void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    return appContext.go(
        routeName); // GoRouter does not allow history manipulation directly, this is an alternative.
  }

  // Pop the current route
  static void pop({Object? params}) {
    appContext.pop(params);
  }

  // Get the current screen route name
  static String currentScreen() {
    return '';
  }
}
