import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appcrudfirestore/screens/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCP5nJ593NxZrzF8zsQVWwYfMyoM1P5ORg",
        authDomain: "bdfirestore-e2381.firebaseapp.com",
        projectId: "bdfirestore-e2381",
        storageBucket: "bdfirestore-e2381.appspot.com",
        messagingSenderId: "418382540646",
        appId: "1:418382540646:web:d8e724b7b26bca919e22a7"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Menu Drawer - Hamburguer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountEmail: Text("storelivros@gmail.com"),
              accountName: Text("JPLivros"),
              currentAccountPicture: CircleAvatar(
                child: Text("JPL's"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
              onTap: () {
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => Login(),
                //     ),
                //    );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Store"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Store()));

                //Navegar para outra página
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Contato"),
              onTap: () {
                Navigator.pop(context);

                //Navegar para outra página
              },
            ),
            ListTile(
              leading: Icon(Icons.person_3_sharp),
              title: Text("Perfil"),
              onTap: () {
                Navigator.pop(context);

                //Navegar para outra página
              },
            ),
          ],
        ),
      ),
      body: Column(children: <Widget>[
        Image.asset(
          'imagens/livro.png',
          fit: BoxFit.fill,
        )
      ]),
    );
  }
}
