import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pi_5ccomp/firebase_options.dart';
import 'package:pi_5ccomp/splash/splash_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
    );
  }
}
