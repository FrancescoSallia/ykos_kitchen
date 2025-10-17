import 'package:flutter/cupertino.dart';
import 'package:ykos_kitchen/Error/app_error_handler.dart';
import 'package:ykos_kitchen/Service/fire_auth.dart';


class ViewmodelFireAuth extends ChangeNotifier {
  final auth = FireAuth();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? loginSuccess;
  String? registerSuccess;
  String? resetPasswordSuccess;
  String? loginError;
  String? registerError;
  String? resetPasswordError;
  String? logoutError;
  String? reAuthError;
  String? reAuthSuccess;
  String? deleteUserError;
  String? logoutSuccess;

  //Login
  Future<void> logIn(String email, String password) async {
    _isLoading = true;
    loginSuccess = null;
    loginError = null;
    notifyListeners();
    try {
      await auth.logIn(email, password);
      loginSuccess = "Succesfully logged in";
      notifyListeners();
    } on Exception catch (e) {
      final errorMessageFromHandler = AppErrorHandler.getMessageFromException(
        e,
      );
      loginError = errorMessageFromHandler;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Register
  Future<void> register(String email, String password) async {
    _isLoading = true;
    registerSuccess = null;
    registerError = null;
    notifyListeners();
    try {
      await auth.register(email, password);
      registerSuccess = "Registation Successful";
      notifyListeners();
    } on Exception catch (e) {
      final errorMessageFromHandler = AppErrorHandler.getMessageFromException(
        e,
      );
      registerError = errorMessageFromHandler;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //resetPassword
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    resetPasswordError = null;
    resetPasswordSuccess = null;
    notifyListeners();
    try {
      await auth.resetPasswort(email);
      resetPasswordSuccess = "if email exist, it will be send";
      notifyListeners();
    } on Exception catch (e) {
      final errorMessageFromHandler = AppErrorHandler.getMessageFromException(
        e,
      );
      resetPasswordError = errorMessageFromHandler;

      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Re-Authentification
  Future<void> reAuth(String email, String password) async {
    _isLoading = true;
    reAuthError = null;
    reAuthSuccess = null;
    notifyListeners();
    try {
      await auth.reAuth(email, password);
      reAuthSuccess = "Re-Authentification send";
      notifyListeners();
    } catch (e) {
      reAuthError = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Delete User
  Future<void> deleteUser() async {
    _isLoading = true;
    deleteUserError = null;
    notifyListeners();
    try {
      await auth.deleteUser();
      notifyListeners();
    } catch (e) {
      deleteUserError = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    logoutError = null;
    logoutSuccess = null;
    _isLoading = true;
    notifyListeners();
    try {
      await auth.logOut();
      logoutSuccess = "Success logout";
    } on Exception catch (e) {
      final message = AppErrorHandler.getMessageFromException(e);
      logoutError = message;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }
}
