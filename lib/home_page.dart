import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ykos_kitchen/theme/colors.dart';
import 'package:dotted_border/dotted_border.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subTitle(),
            Divider(thickness: 2, height: 0, color: Colors.grey),

            orderProgressTitle("NEU", 0),
            dottedBox("Neue Aufträge hier!"),
            SizedBox(height: 25),
            orderProgressTitle("KÜCHE", 0),
            dottedBox(
              "Hier werden die Gerichte von der Bestellung zubereitet.",
            ),
            SizedBox(height: 25),
            orderProgressTitle("UNTERWEGS", 0),
            dottedBox("Die Bestellungen sind hier Unterwegs."),
            SizedBox(height: 25),
            orderProgressTitle("GELIEFERT", 0),
            dottedBox("Alle gelieferten Bestellungen befinden sich hier."),
          ],
        ),
      ),
    );
  }

  Padding dottedBox(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: Colors.grey,
          dashPattern: [3, 2],
          strokeWidth: 2,
          padding: EdgeInsets.symmetric(vertical: 60),
        ),
        child: Center(
          child: Text(
            description,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Padding orderProgressTitle(String title, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Text(
        "$title ($amount)",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 32, 88, 119),
          fontSize: 17,
        ),
      ),
    );
  }

  Container subTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 16, left: 15),
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
    );
  }
}
