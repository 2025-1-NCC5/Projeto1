import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController origemController = TextEditingController();
final TextEditingController destinoController = TextEditingController();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> calcularPrecoViagem(BuildContext context) async {
    final origem = origemController.text;
    final destino = destinoController.text;

    if (origem.isEmpty || destino.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erro'),
          content: Text('Por favor, preencha ambos os campos.'),
        ),
      );
      return;
    }

    final flaskApiUrl = 'http://15.229.102.105:3001/predict';

    try {
      final response = await http.post(
        Uri.parse(flaskApiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "origin": origem,
          "destination": destino,
        }),
      );

      print("Status da resposta da API Flask: ${response.statusCode}");
      print("Resposta da API Flask: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final preco = result['price'];
        final distance = result['distance_m'];

        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('viagens').add({
            'uid': user.uid,
            'email': user.email,
            'origem': origem,
            'destino': destino,
            'preco_estimado': preco,
            'distancia_metros': distance,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Preço estimado'),
            content: Text(
              'R\$ ${preco.toStringAsFixed(2)}\nDistância: ${(distance / 1000).toStringAsFixed(2)} km',
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Erro na API Flask'),
            content: Text('Erro ao consultar a API Flask: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao consultar a API: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página Principal"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoricoViagensPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
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
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
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
      ),
    );
  }
}

class HistoricoViagensPage extends StatelessWidget {
  const HistoricoViagensPage({super.key});

  Future<List<Map<String, dynamic>>> buscarHistoricoUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('viagens')
        .where('uid', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Viagens')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: buscarHistoricoUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final viagens = snapshot.data ?? [];

          if (viagens.isEmpty) {
            return Center(child: Text('Nenhuma viagem encontrada.'));
          }

          return ListView.builder(
            itemCount: viagens.length,
            itemBuilder: (context, index) {
              final viagem = viagens[index];
              return ListTile(
                leading: Icon(Icons.location_on),
                title: Text('${viagem['origem']} → ${viagem['destino']}'),
                subtitle: Text(
                    'R\$ ${viagem['preco_estimado']?.toStringAsFixed(2)} - ${(viagem['distancia_metros'] / 1000).toStringAsFixed(2)} km'),
              );
            },
          );
        },
      ),
    );
  }
}
