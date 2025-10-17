import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:ykos_kitchen/components/complete_button.dart';
import 'package:ykos_kitchen/components/my_logo.dart';
import 'package:ykos_kitchen/components/my_textfield.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_fire_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
  final TextEditingController _resetPasswordController =
      TextEditingController();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String? emailError;

  @override
  void initState() {
    final viewmodelAuth = context.read<ViewmodelFireAuth>();
    viewmodelAuth.resetPasswordSuccess = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelAuth = context.watch<ViewmodelFireAuth>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModelAuth.resetPasswordError != null) {
        emailError = viewModelAuth.resetPasswordError;
        IconSnackBar.show(
          context,
          label: viewModelAuth.resetPasswordError!,
          snackBarType: SnackBarType.fail,
        );
      }
      if (viewModelAuth.resetPasswordSuccess != null) {
        IconSnackBar.show(
          context,
          label: viewModelAuth.resetPasswordSuccess!,
          snackBarType: SnackBarType.success,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text("Reset Password"),
        centerTitle: true,
      ),
      backgroundColor: AppColors.secondary,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [MyLogo(), SizedBox(width: 15)],
          ),
          SizedBox(height: 100),
          MyTextfield(
            controller: widget._resetPasswordController,
            hintText: "E-mail",
            obscure: false,
            icon: Icons.email_outlined,
            errorText: emailError,
          ),
          SizedBox(height: 50),
          CompleteButton(
            text: "Send E-mail",
            gesture: () async {
              final email = widget._resetPasswordController.text;

              if (email.isNotEmpty) {
                await viewModelAuth.resetPassword(email);
              } else {
                setState(() {
                  emailError = "Überprüfe deine eingabe";
                });
              }
            },
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
