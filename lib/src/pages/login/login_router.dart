import 'package:fe_lab_clinicas_adm/src/repositories/users/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import '../../repositories/users/user_repository.dart';
import '../../services/user_login_service.dart';
import '../../services/user_login_service_impl.dart';
import 'login_controller.dart';
import 'login_page.dart';

class LoginRouter extends FlutterGetItPageRouter {
  const LoginRouter({super.key});

  @override
  String get routeName => '/login';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<UserRepository>(
            (i) => UserRepositoryImpl(restClient: i())),
        Bind.lazySingleton<UserLoginService>(
            (i) => UserLoginServiceImpl(userRepository: i())),
        Bind.lazySingleton((i) => LoginController(userLoginService: i()))
      ];

  @override
  WidgetBuilder get view => (_) => const LoginPage();
}
