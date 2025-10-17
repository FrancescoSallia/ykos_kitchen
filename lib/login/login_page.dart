import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ykos_kitchen/components/complete_button.dart';
import 'package:ykos_kitchen/components/my_logo.dart';
import 'package:ykos_kitchen/components/my_textfield.dart';
import 'package:ykos_kitchen/login/reset_password_page.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_fire_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginSelected = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  bool _showPasswort = true;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    context.read<ViewmodelFireAuth>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelAuth = context.watch<ViewmodelFireAuth>();

    // Snackbar anzeigen, wenn ein Fehler oder Erfolg vorhanden ist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModelAuth.loginError != null) {
        AnimatedSnackBar.material(
          viewModelAuth.loginError!,
          type: AnimatedSnackBarType.error,
        ).show(context);
        viewModelAuth.loginError = null;
      }
      if (viewModelAuth.registerError != null) {
        AnimatedSnackBar.material(
          viewModelAuth.registerError!,
          type: AnimatedSnackBarType.error,
        ).show(context);

        viewModelAuth.registerError = null;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.secondary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Logo Image
              MyLogo(),
              const SizedBox(height: 50),

              // Toggle container
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated highlight background
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment:
                          isLoginSelected
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildToggleButton("Log In", true),
                        _buildToggleButton("Sign Up", false),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              MyTextfield(
                controller: _controllerEmail,
                hintText: "E-mail",
                obscure: false,
                icon: Icons.email,
                errorText: emailError,
              ),
              SizedBox(height: 10),
              MyTextfield(
                controller: _controllerPassword,
                hintText: "Password",
                obscure: _showPasswort,
                icon: _showPasswort ? Icons.visibility : Icons.visibility_off,
                errorText: passwordError,
                iconOnPress: () {
                  setState(() {
                    _showPasswort = !_showPasswort;
                  });
                },
              ),
              SizedBox(height: 10),
              Visibility(
                visible: isLoginSelected == false ? true : false,
                child: MyTextfield(
                  controller: _controllerConfirmPassword,
                  hintText: "Confirm Password",
                  obscure: _showPasswort,
                  errorText: confirmPasswordError,
                  icon: _showPasswort ? Icons.visibility : Icons.visibility_off,
                  iconOnPress: () {
                    setState(() {
                      _showPasswort = !_showPasswort;
                    });
                  },
                ),
              ),
              Visibility(
                visible: isLoginSelected ? true : false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgor Password?",
                          style: TextStyle(
                            color: AppColors.textFieldColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              CompleteButton(
                text: isLoginSelected ? "Log In" : "Sign Up",
                gesture: () async {
                  final email = _controllerEmail.text.trim();
                  final password = _controllerPassword.text;
                  final confirmPassword = _controllerConfirmPassword.text;

                  setState(() {
                    emailError = email.isEmpty ? "Bitte E-Mail eingeben" : null;
                    passwordError =
                        password.isEmpty ? "Bitte Passwort eingeben" : null;
                    confirmPasswordError =
                        (!isLoginSelected && confirmPassword != password)
                            ? "Passwörter stimmen nicht überein"
                            : null;
                  });

                  if (emailError != null ||
                      passwordError != null ||
                      confirmPasswordError != null) {
                    return;
                  }

                  if (isLoginSelected) {
                    await viewModelAuth.logIn(email, password);
                  } else {
                    await viewModelAuth.register(email, password);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isLoginButton) {
    final bool isSelected =
        (isLoginButton && isLoginSelected) ||
        (!isLoginButton && !isLoginSelected);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLoginSelected = isLoginButton;
          });
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

extension LoginError on int {
  String get errorText {
    switch (this) {
      case 0:
        return "Check you Email";
      case 1:
        return "Check you Password";
      case 2:
        return "Confirm you Password correctly";
      default:
        return "Check this Textfield";
    }
  }
}
