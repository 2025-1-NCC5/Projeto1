import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoricoViagensPage extends StatelessWidget {
  const HistoricoViagensPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Histórico de Viagens')),
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }

    final viagensStream = FirebaseFirestore.instance
        .collection('viagens')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Viagens')),
      body: StreamBuilder<QuerySnapshot>(
        stream: viagensStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados.'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(child: Text('Nenhuma viagem encontrada.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final origem = data['origem'] ?? 'Origem desconhecida';
              final destino = data['destino'] ?? 'Destino desconhecido';
              final preco = (data['preco_estimado'] ?? 0).toStringAsFixed(2);
              final distanciaKm = ((data['distancia_metros'] ?? 0) / 1000).toStringAsFixed(1);

              return ListTile(
                leading: Icon(Icons.location_on),
                title: Text('$origem → $destino'),
                subtitle: Text('Preço: R\$ $preco - Distância: $distanciaKm km'),
              );
            },
          );
        },
      ),
    );
  }
}
