import 'package:flutter/material.dart';
import 'package:pi_5ccomp/components/decoration_auth.dart';
import 'package:pi_5ccomp/screens/authentication/registration_page.dart';
import 'package:pi_5ccomp/screens/home.dart';
import '../../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1000, 28, 140, 164),
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
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text("É novo por aqui? Registre-se"),
              ),
              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "E-mail",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: getAuthenticationInputDecoration("Digite seu email"),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Senha",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: getAuthenticationInputDecoration("Digite sua senha"),
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => recuperarSenha(),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text("Esqueci minha senha"),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  signIn();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 50),
                  backgroundColor: const Color.fromARGB(1000, 217, 217, 217),
                  foregroundColor: const Color.fromARGB(1000, 28, 140, 164),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                ),
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await authService.value.signIn(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer login: $e")),
      );
    }
  }

  void recuperarSenha() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite seu e-mail para recuperar a senha.")),
      );
      return;
    }

    try {
      await authService.value.resetPassword(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-mail de recuperação enviado! Verifique sua caixa de entrada.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar e-mail: $e")),
      );
    }
  }
}
