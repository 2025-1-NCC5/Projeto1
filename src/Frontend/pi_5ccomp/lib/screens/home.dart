import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'alterar_senha.dart';
import 'historicoViagens_Page.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final origemController = TextEditingController();
  final destinoController = TextEditingController();

  double? preco;
  double? distancia;

  Future<void> calcularPrecoViagem(BuildContext context) async {
    final origem = origemController.text;
    final destino = destinoController.text;

    if (origem.isEmpty || destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    final flaskApiUrl = 'http://15.229.102.105:3001/predict';

    try {
      final response = await http.post(
        Uri.parse(flaskApiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"origin": origem, "destination": destino}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final precoValor = (result['price'] as num).toDouble();
        final distanciaValor = (result['distance_m'] as num).toDouble();

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('viagens').add({
            'uid': user.uid,
            'email': user.email,
            'origem': origem,
            'destino': destino,
            'preco_estimado': precoValor,
            'distancia_metros': distanciaValor,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        setState(() {
          preco = precoValor;
          distancia = distanciaValor;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na API Flask: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao consultar a API: $e')),
      );
    }
  }
  Future<void> abrirUber() async {
    const url = 'uber://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Fallback para o site caso o app não esteja instalado
      await launchUrl(Uri.parse('https://m.uber.com'));
    }
  }

  Future<void> abrir99() async {
    const url = 'ninety_nine://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Fallback para o site caso o app não esteja instalado
      await launchUrl(Uri.parse('https://99app.com/passenger'));
    }
  }


  void mostrarDialogoEscolhaApp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Abrir com...'),
        content: Text('Deseja abrir a corrida com qual app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              abrirUber();
            },
            child: Text('Uber'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              abrir99();
            },
            child: Text('99'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 28, 140, 164)),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Página Inicial'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico de Viagens'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoricoViagensPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_reset),
              title: Text('Alterar Senha'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AlterarSenhaPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(""),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoricoViagensPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: origemController,
                        decoration: InputDecoration(
                          hintText: "Local Inicial",
                          filled: true,
                          fillColor: Color.fromARGB(1000, 217, 217, 217),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: destinoController,
                        decoration: InputDecoration(
                          hintText: "Destino Final",
                          filled: true,
                          fillColor: Color.fromARGB(1000, 217, 217, 217),
                          prefixIcon: Icon(Icons.location_pin),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(1000, 28, 140, 164),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () => calcularPrecoViagem(context),
                    ),
                  ),
                ),
              ],
            ),
            if (preco != null && distancia != null)
              GestureDetector(
                onTap: mostrarDialogoEscolhaApp,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preço estimado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text('R\$ ${preco!.toStringAsFixed(2)}'),
                      Text('Distância: ${(distancia! / 1000).toStringAsFixed(2)} km'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
