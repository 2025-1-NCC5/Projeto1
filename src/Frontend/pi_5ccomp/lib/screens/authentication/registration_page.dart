import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_5ccomp/components/decoration_auth.dart';
import 'package:pi_5ccomp/screens/authentication/login_page.dart';
import 'package:pi_5ccomp/screens/home.dart';
import 'package:pi_5ccomp/services/auth_services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  // Controladores de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1000, 28, 140, 164),
        body: SingleChildScrollView(
        child: Center(
        child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
    child: Padding(
    padding: const EdgeInsets.all(40.0),
    child: Form(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bem Vindo!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, animation, secundaryAnimation) => LoginPage(title: "Home page", onToggleTheme: (){},),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final offsetAnimation = Tween<Offset>(
                              begin: Offset(-1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                                position: offsetAnimation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child));
                          }),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Já possui cadastro?",
                        ),
                        TextSpan(
                          text: " Entre aqui!",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 2.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("E-mail", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: emailController,
                  decoration: getAuthenticationInputDecoration("Digite seu email"),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: passwordController,
                  decoration: getAuthenticationInputDecoration("Digite sua senha"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirme sua senha", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: confirmPasswordController,
                  decoration: getAuthenticationInputDecoration("Confirme sua senha"),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    register(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    backgroundColor: const Color.fromARGB(1000, 217, 217, 217),
                    foregroundColor: const Color.fromARGB(1000, 28, 140, 164),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),
                  child: const Text("Registrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
        ),
    );
  }
String errorMessage = "";

  void register(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    try {
      await authService.value.createAccount(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: "Home page", onToggleTheme: () {  },)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Erro desconhecido ao registrar")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro inesperado ao registrar")),
      );
    }

  }
}
