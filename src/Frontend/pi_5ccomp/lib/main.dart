import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pi_5ccomp/firebase_options.dart';
import 'package:pi_5ccomp/screens/home.dart';
import 'package:pi_5ccomp/screens/authentication/login_page.dart';
import 'package:pi_5ccomp/splash/splash_page.dart';
import 'package:pi_5ccomp/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      //Tema claro
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(Color(0xFF1C8CA4)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black)
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
      ),
      prefixIconColor: Colors.black,
    ),
    ),

      //Tema Escuro
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: createMaterialColor(Color(0xFF1C8CA4)),
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white)
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
      ),
      prefixIconColor: Colors.black,
    ),
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage(); // enquanto carrega
          }

          if (snapshot.hasData) {
            return HomePage(onToggleTheme: toggleTheme); // usuário logado
          }

          return LoginPage(title: 'Login', onToggleTheme: toggleTheme,); // não logado
        },
      ),
    );
  }
}
