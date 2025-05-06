import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_5ccomp/components/decoration_auth.dart';
import 'package:pi_5ccomp/screens/authentication/login_page.dart';
import 'package:pi_5ccomp/screens/home.dart';
import 'package:pi_5ccomp/services/auth_services.dart';

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
                const Text(
                  "BEM VINDO!",
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
                      MaterialPageRoute(builder: (context) => const LoginPage(title: "Home page")),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text("Já possui cadastro? Entre aqui"),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("E-mail", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: getAuthenticationInputDecoration("Digite seu email"),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
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
        MaterialPageRoute(builder: (context) => const LoginPage(title: "Home page")),
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
