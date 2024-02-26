import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessageViewMixin {
  final controller = Injector.get<LoginController>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.loggedIn) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(minHeight: sizeOf.height),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            constraints: BoxConstraints(maxWidth: sizeOf.width * 0.4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text('Login', style: AppTheme.titleStyle),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.email('Email inválido'),
                      Validatorless.required('Email obrigatório'),
                    ]),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Watch(
                    (_) {
                      return TextFormField(
                        controller: passwordEC,
                        obscureText: controller.obscurePassword,
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(6, 'Senha muito curta'),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () => controller.obscurePasswordToggle(),
                            icon: Icon(controller.obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                      width: sizeOf.width * 0.8,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            if (valid) {
                              controller.login(emailEC.text, passwordEC.text);
                            }
                          },
                          child: const Text('ENTRAR'))),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
