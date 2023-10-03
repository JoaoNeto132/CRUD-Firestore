import 'package:flutter/material.dart';
import 'package:appcrudfirestore/main.dart';

void main() => runApp(MyApp());

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
                Navigator.pop(context);

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
