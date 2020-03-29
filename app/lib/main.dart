import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:convert';

void main() {
  HttpRequest.getString('mock-api/professions.json').then((myjson) {
    List<dynamic> data = json.decode(myjson);
    debugPrint(data.toString());
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morphosis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeef9bf),
      child: Center(
        child: Container(
          width: 640,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Image.asset(
                    'assets/logo.png',
                    semanticLabel: 'Logo',
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/morphosis.png',
                    semanticLabel: 'Logo Title',
                    width: 240,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 8),
                  child: Text(
                    'Find alternative job ideas from people who had the same profession you did before social distancing.',
                    style: TextStyle(color: Color(0xff6a8caf), fontSize: 16, ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Color(0xff75b79e),
                    textColor: Colors.white,
                    onPressed: () {
                      ;
                    },
                    child: Text('Start', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),),
                  ),
                ),
              ],
            ),
          ),
          color: Color(0xffeef9bf),
        ),
      ),
    );
  }
}
