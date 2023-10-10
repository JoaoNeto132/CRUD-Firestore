import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _Store();
}

class _Store extends State<Store> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';
      _nomeController.text = documentSnapshot['nome'];
      _bairroController.text = documentSnapshot['bairro'];
      _cepController.text = documentSnapshot['cep'];
      _cidadeController.text = documentSnapshot['cidade'];
      _ufController.text = documentSnapshot['uf'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _bairroController,
                  decoration: const InputDecoration(labelText: 'Bairo'),
                ),
                TextField(
                  controller: _cepController,
                  decoration: const InputDecoration(labelText: 'CEP'),
                ),
                TextField(
                  controller: _ufController,
                  decoration: const InputDecoration(labelText: 'UF'),
                ),
                TextField(
                  controller: _cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Salvar' : 'Alterar'),
                  onPressed: () async {
                    final String? nome = _nomeController.text;
                    final String? bairro = _bairroController.text;
                    final String? cep = _cepController.text;
                    final String? cidade = _cidadeController.text;
                    final String? uf = _ufController.text;

                    if (nome != null &&
                        bairro != null &&
                        cep != null &&
                        cidade != null &&
                        uf != null) {
                      if (action == 'create') {
                        await _user.add({
                          "nome": nome,
                          "bairro": bairro,
                          "cep": cep,
                          "cidade": cidade,
                          "uf": uf
                        });
                      }

                      if (action == 'update') {
                        await _user.doc(documentSnapshot!.id).update({
                          "nome": nome,
                          "bairro": bairro,
                          "cep": cep,
                          "cidade": cidade,
                          "uf": uf
                        });
                      }

                      _nomeController.text = '';
                      _bairroController.text = '';
                      _cepController.text = '';
                      _cidadeController.text = '';
                      _ufController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String storeId) async {
    await _user.doc(storeId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Livro excluído!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppCrudFirestore'),
      ),
      body: StreamBuilder(
        stream: _user.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nome']),
                    subtitle: Text(documentSnapshot['bairro']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class pressed {}
