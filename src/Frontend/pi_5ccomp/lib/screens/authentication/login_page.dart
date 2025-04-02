import 'package:flutter/material.dart';
import 'package:pi_5ccomp/components/decoration_auth.dart';
import 'package:pi_5ccomp/screens/authentication/registration_page.dart';
import 'package:pi_5ccomp/screens/home.dart';



//LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(1000, 28, 140, 164),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "OLÁ!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                ),
                child: Text("É novo por aqui? Registre-se"),
              ),
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "E-mail",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                decoration: getAuthenticationInputDecoration("Digite seu email"),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Senha",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                decoration: getAuthenticationInputDecoration("Digite sua senha"),
                obscureText: true,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(180, 50),
                      backgroundColor: Color.fromARGB(1000, 217, 217, 217),
                      foregroundColor: Color.fromARGB(1000, 28, 140, 164),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                  child: Text("Login"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
