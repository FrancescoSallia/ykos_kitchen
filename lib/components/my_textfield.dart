import 'package:flutter/material.dart';
import 'package:ykos_kitchen/theme/colors.dart';

class MyTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final IconData? icon;
  final String? errorText;
  final Function()? iconOnPress; // Callback-Funktion von außen

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.icon,
    this.iconOnPress,
    this.errorText,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 50.0,
            right: 50.0,
            top: 5,
            bottom: 0,
          ),
          child: TextField(
            obscureText: widget.obscure,
            controller: widget.controller,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis),
            decoration: InputDecoration(
              errorText: widget.errorText,
              errorStyle: TextStyle(color: Colors.red),
              border: UnderlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.icon,
                  color: AppColors.textFieldColor,
                  size: 20,
                ),
                onPressed: widget.iconOnPress,
              ),
              enabledBorder: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: AppColors.textFieldColor),
            ),
            onChanged: (value) {
              setState(() {
                widget.controller.text = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
