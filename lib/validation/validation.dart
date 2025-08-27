import 'package:chat_app/utilities/pops.dart';

bool validateRegister(
    String name, String email, String password, String confirmPassword) {
  if (name.isEmpty) {
    Pops.showError('Please fill name');
    return false;
  } else if (email.isEmpty) {
    Pops.showError('Please fill email');
    return false;
  } else if (password.isEmpty) {
    Pops.showError('Please fill password');
    return false;
  } else if (confirmPassword.isEmpty) {
    Pops.showError('Please fill confrim password');
    return false;
  } else if (password.length < 6) {
    Pops.showError('Password should be atleast 6 characters');
    return false;
  } else if (password != confirmPassword) {
    Pops.showError('Password not matched');
    return false;
  }
  return true;
}

bool validateLogin(String email, String password) {
  if (email.isEmpty) {
    Pops.showError('Please fill email');
    return false;
  } else if (password.isEmpty) {
    Pops.showError('Please fill password');
    return false;
  }
  return true;
}
