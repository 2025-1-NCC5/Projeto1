import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoricoViagensPage extends StatelessWidget {
  const HistoricoViagensPage({super.key});

  void mostrarDialogoEscolhaApp(BuildContext context, String destino) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Abrir com...'),
        content: const Text('Deseja abrir a corrida com qual app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              abrirUber();
            },
            child: const Text('Uber'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              abrir99();
            },
            child: const Text('99'),
          ),
        ],
      ),
    );
  }

  Future<void> abrirUber() async {
    const url = 'uber://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      
      await launchUrl(Uri.parse('https://m.uber.com'));
    }
  }

  Future<void> abrir99() async {
    const url = 'ninety_nine://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {

      await launchUrl(Uri.parse('https://99app.com/passenger'));
    }
  }

  void confirmarExclusaoTotal(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir todo o histórico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final snapshot = await FirebaseFirestore.instance
                  .collection('viagens')
                  .where('uid', isEqualTo: uid)
                  .get();
              for (var doc in snapshot.docs) {
                await doc.reference.delete();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Histórico excluído com sucesso')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void confirmarExclusaoIndividual(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir viagem'),
        content: const Text('Deseja excluir essa viagem do histórico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance.collection('viagens').doc(docId).delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viagem excluída.')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Histórico de Viagens')),
        body: const Center(child: Text('Usuário não autenticado.')),
      );
    }

    final viagensStream = FirebaseFirestore.instance
        .collection('viagens')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Histórico de Viagens'),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: viagensStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar dados.'));
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Center(child: Text('Nenhuma viagem encontrada.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  final origem = data['origem'] ?? 'Origem desconhecida';
                  final destino = data['destino'] ?? 'Destino desconhecido';
                  final preco = (data['preco_estimado'] ?? 0).toStringAsFixed(2);
                  final distanciaKm = ((data['distancia_metros'] ?? 0) / 1000).toStringAsFixed(1);

                  return GestureDetector(
                    onTap: () => mostrarDialogoEscolhaApp(context, destino),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 6, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.location_on,
                              size: 32,
                              color: Theme.of(context).iconTheme.color,),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$origem → $destino', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Preço: R\$ $preco - Distância: $distanciaKm km'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 28, 140, 164)),
                            onPressed: () => confirmarExclusaoIndividual(context, doc.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 28, 140, 164),
              onPressed: () => confirmarExclusaoTotal(context, uid),
              child: const Icon(Icons.delete, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
