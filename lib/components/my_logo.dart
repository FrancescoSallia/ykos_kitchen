import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("lib/img/logo_ykos.png", width: 150),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Image.asset("lib/img/ykos_title.png", width: 120),
          ],
        ),
      ],
    );
  }
}
