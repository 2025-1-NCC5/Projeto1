import 'package:flutter/material.dart';
import 'package:pi_5ccomp/screens/authentication/login_page.dart';

class AuthController {
  Future<void> currentUser(BuildContext context) async {
    //Duração da tela em segundos
    await Future.delayed(Duration(seconds: 6));
    Navigator.pushReplacement(context,MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            LoginPage(title: "Home page"))//Direciona para proxima tela
    );
  }
}