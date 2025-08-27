import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/router/app_routes.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/utilities/pops.dart';
import 'package:chat_app/validation/validation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthService authService = AuthService();

  void registerUser(String name, String email, String password,
      String confirmPassword) async {
    Pops.startLoading();
    try {
      bool isValidate =
          validateRegister(name, email, password, confirmPassword);
      if (isValidate) {
        final isRegistered =
            await authService.registerUser(name, email, password);
        if (isRegistered) {
          Get.toNamed(AppRoutes.loginView);
          Pops.showToast('Registered successfully');
        }
      }
    } on AuthException catch (e) {
      Pops.showError(e.message);
    } catch (e) {
      Pops.showError('An unexpected error occurred. Please try again.');
    } finally {
      Pops.stopLoading();
    }
  }

  void loginUser(String email, String password) async {
    Pops.startLoading();
    try {
      bool isValidate = validateLogin(email, password);
      if (isValidate) {
        final isLogin = await authService.loginUser(email, password);
        if (isLogin) {
          Get.toNamed(AppRoutes.homeView);
          Pops.showToast('Login successfully');
        }
      }
    } on AuthException catch (e) {
      Pops.showError(e.message);
    } catch (e) {
      Pops.showError('An unexpected error occurred. Please try again.');
    } finally {
      Pops.stopLoading();
    }
  }
}
