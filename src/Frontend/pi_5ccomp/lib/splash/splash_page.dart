import 'package:flutter/material.dart';
import 'package:pi_5ccomp/screens/authentication/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();
    authController.currentUser(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 217, 217, 217),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/logo_preta.png", height: 128),
          Text(
            "Seu estimador de preços de corridas favorito!",
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
