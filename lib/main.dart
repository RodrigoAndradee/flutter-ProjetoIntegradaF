import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_app/StorageUtil.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/pages/home_screen.dart';

Future<Album> validateLogin(String emailController, String passwordController, BuildContext context) async {

  final user = jsonEncode({
    'email': emailController,
    'password' : passwordController,});

  final http.Response response = await http.post(
    'http://192.168.1.109:3000/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: user,
  );

  if (response.statusCode == 200) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteWidget()),
    );
  } else {
    print(response.statusCode);
  }
}

class Album {
  final String name;
  final String accessToken;

  Album({this.name, this.accessToken});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      accessToken: json['accessToken'],
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Input Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0.0, 20.0, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'E-mail:'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                ),
                TextFormField(
                  controller: passwordController,
                  // obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'Senha:'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                ),
                RaisedButton(
                  onPressed: () => {validateLogin(emailController.text, passwordController.text, context)},
                  child: const Text('Login', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
