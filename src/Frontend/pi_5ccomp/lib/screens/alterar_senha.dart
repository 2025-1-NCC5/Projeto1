import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pi_5ccomp/services/auth_services.dart';
import '../components/decoration_auth.dart'; // Ajuste o caminho conforme sua estrutura de pastas

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _alterarSenha() async {
    final senhaAtual = _senhaAtualController.text.trim();
    final novaSenha = _novaSenhaController.text.trim();
    final confirmarSenha = _confirmarSenhaController.text.trim();

    if (novaSenha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem.")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário não autenticado.")),
      );
      return;
    }

    try {
      await authService.value.resetPwFromCurrentPw(
        currentPassword: senhaAtual,
        newPassword: novaSenha,
        email: user.email!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha alterada com sucesso!")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensagemErro;
      switch (e.code) {
        case 'wrong-password':
          mensagemErro = "Senha atual incorreta.";
          break;
        case 'weak-password':
          mensagemErro = "A nova senha é muito fraca.";
          break;
        case 'requires-recent-login':
          mensagemErro = "Reautenticação necessária. Faça login novamente.";
          break;
        default:
          mensagemErro = "Erro ao alterar senha: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Alterar Senha")),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                  isDarkMode ? 'assets/logo_cinza.png' : 'assets/logo_preta.png',
                  height: 80),
              const SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _senhaAtualController,
                obscureText: true,
                decoration: getAuthenticationInputDecoration("Senha Atual")
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _novaSenhaController,
                obscureText: true,
                decoration: getAuthenticationInputDecoration("Nova Senha")
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: getAuthenticationInputDecoration("Confirmar Nova Senha")
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _alterarSenha,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 50),
                  backgroundColor: const Color.fromARGB(1000, 28, 140, 164),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                ),
                child: const Text("Alterar Senha"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
