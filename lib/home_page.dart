import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        249,
        249,
        249,
      ).withValues(alpha: 0.9),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Image.asset("lib/img/logo_ykos.png"),
              ),
            ),
            SizedBox(width: 5),
            SizedBox(
              height: 70,
              width: 70,
              child: Image.asset("lib/img/ykos_title.png"),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        width: 300,
        backgroundColor: AppColors.primary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings_outlined),
              onTap: () {},
            ),
            ListTile(
              title: Text("Adress"),
              // trailing: Icon(AdressEnum.suit.label),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 16,
                    left: 15,
                  ),
                  child: Text(
                    "HEUTIGE BESTELLUNGEN",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: AppColors.timerPrimary2,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2, height: 0, color: Colors.grey),
        ],
      ),
    );
  }
}
