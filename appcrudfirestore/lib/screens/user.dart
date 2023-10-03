import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _enderecoController = TextEditingController();

  final TextEditingController _celularController = TextEditingController();

  final TextEditingController _cidadeController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  //final TextEditingController _imageController = TextEditingController();

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';

      _nomeController.text = documentSnapshot['nome'];

      _enderecoController.text = documentSnapshot['endereco'];

      _celularController.text = documentSnapshot['celular'];

      _cidadeController.text = documentSnapshot['cidade'];

      _emailController.text = documentSnapshot['email'];

      //_imageController.text = documentSnapshot['image'];
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

// prevent the soft keyboard from covering text fields

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
                  controller: _enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),

                TextField(
                  controller: _celularController,
                  decoration: const InputDecoration(labelText: 'Celular'),
                ),

                TextField(
                  // keyboardType:

                  //   const TextInputType.numberWithOptions(decimal: true),

                  controller: _cidadeController,

                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                  ),
                ),

                //TextField(

                //  controller: _imageController,

                //  decoration: const InputDecoration(labelText: 'Imagem'),

                //),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  child: Text(action == 'create' ? 'Salvar' : 'Alterar'),
                  onPressed: () async {
                    final String? nome = _nomeController.text;

                    final String? endereco = _enderecoController.text;

                    //final double? price =

                    //  double.tryParse(_priceController.text);

                    final String? celular = _celularController.text;

                    final String? cidade = _cidadeController.text;

                    if (nome != null &&
                        endereco != null &&
                        celular != null &&
                        cidade != null) {
                      if (action == 'create') {
// Persist a new product to Firestore

                        await _user.add({
                          "nome": nome,
                          "endereco": endereco,
                          "celular": celular,
                          "cidade": cidade
                        });
                      }

                      if (action == 'update') {
// Update the product

                        await _user.doc(documentSnapshot!.id).update({
                          "nome": nome,
                          "endereco": endereco,
                          "celular": celular,
                          "cidade": cidade
                        });
                      }

                      // Clear the text fields

                      _nomeController.text = '';

                      _enderecoController.text = '';

                      _celularController.text = '';

                      _cidadeController.text = '';

                      //_imageController.text = '';

                      // Hide the bottom sheet

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id

  Future<void> _deleteProduct(String productId) async {
    await _user.doc(productId).delete();

// Show a snackbar

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Chocolate excluído!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppCrudFirestore'),
      ),

// Using StreamBuilder to display all products from Firestore in real-time

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
                    subtitle: Text(documentSnapshot['email'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
// Press this button to edit a single product

                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),

// This icon button is used to delete a single product

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

// Add new product

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class pressed {}
