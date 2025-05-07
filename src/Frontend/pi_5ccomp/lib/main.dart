import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pi_5ccomp/firebase_options.dart';
import 'package:pi_5ccomp/screens/home.dart';
import 'package:pi_5ccomp/screens/authentication/login_page.dart';
import 'package:pi_5ccomp/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage(); // enquanto carrega
          }

          if (snapshot.hasData) {
            return const HomePage(); // usuário logado
          }

          return const LoginPage(title: 'Login'); // não logado
        },
      ),
    );
  }
}
