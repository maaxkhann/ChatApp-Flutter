import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/utilities/pops.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserService userService = UserService();
  final userModel = Rxn<UserModel>();
  final RxSet<String> selectedUsers = <String>{}.obs;

  Stream<List<UserModel>> getUsers() {
    return userService.getUsers().handleError((error) {
      if (error is AppException) {
        Pops.showError(error.message);
      } else {
        Pops.showError('Something went wrong');
      }
    });
  }

  void getUserData() {
    userService.getUserData().then((val) {
      userModel.value = val;
    });
  }
}
