import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ykos_kitchen/Service/fire_auth.dart';
import 'package:ykos_kitchen/home_page.dart';
import 'package:ykos_kitchen/login/login_page.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_fire_auth.dart';
import 'package:ykos_kitchen/viewmodel/viewmodel_orders.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewmodelOrders()),
        ChangeNotifierProvider(create: (_) => ViewmodelFireAuth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      home: StreamBuilder(
        stream: FireAuth.auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
