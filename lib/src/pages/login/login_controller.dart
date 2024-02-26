import 'package:asyncstate/asyncstate.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../services/user_login_service.dart';

class LoginController with MessageStateMixin {
  final UserLoginService _userLoginService;

  LoginController({
    required UserLoginService userLoginService,
  }) : _userLoginService = userLoginService;

  final _obscurePassword = signal(true);
  final _loggedIn = signal(false);

  bool get loggedIn => _loggedIn();
  bool get obscurePassword => _obscurePassword();

  void obscurePasswordToggle() =>
      _obscurePassword.value = !_obscurePassword.value;

  Future<void> login(String email, String password) async {
    final loginResult =
        await _userLoginService.execute(email, password).asyncLoader();

    switch (loginResult) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: _):
        _loggedIn.value = true;
    }
  }
}
