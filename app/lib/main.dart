import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:collection';

void main() {
  Global.init();
  runApp(MyApp());
}

class Recommendation {
  String uid;
  String title;
  String description;

  Recommendation({this.uid, this.title, this.description});
}

class Global {
  static Map<String, String> professions;
  static ListQueue<dynamic> recommendations;
  static String selectedProfesionID = '';

  Global.init() {
    professions = {};
    recommendations = ListQueue();
    loadNetwork();
  }

  loadNetwork() async {
    HttpRequest.getString('mock-api/professions.json').then((myjson) {
      List<dynamic> data = json.decode(myjson);
      professions = Map.fromEntries(
          data.map((obj) => MapEntry(obj['uid'], obj['title'])));
      // debugPrint('professions: ' + professions.toString());
    });

    HttpRequest.getString('mock-api/recommendations.json').then((myjson) {
      List<dynamic> data = json.decode(myjson);
      recommendations = ListQueue.from(data.map((obj) => Recommendation(
          uid: obj['uid'],
          title: obj['title'],
          description: obj['description'])));
      debugPrint('recommendations: ' + recommendations.toString());
    });
  }

  static setSelectedProfession(String professionID) {
    selectedProfesionID = professionID;
  }

  static getSelectedProfessionTitle() {
    return professions[selectedProfesionID];
  }

  static getNextRecommendation() {
    Recommendation r = recommendations.removeFirst();
    recommendations.addLast(r);
    return r;
  }
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
    return Scaffold(
      backgroundColor: Color(0xffeef9bf),
      body: Center(
        child: Container(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.asset(
                    'assets/logo.png',
                    semanticLabel: 'Logo',
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Image.asset(
                    'assets/morphosis.png',
                    semanticLabel: 'Logo Title',
                    width: 240,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                  child: Text(
                    'Find alternative job ideas during and after social distancing.',
                    style: TextStyle(
                      color: Color(0xff6a8caf),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Color(0xff75b79e),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectProfessionPage()));
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
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

class SelectProfessionPage extends StatefulWidget {
  @override
  _SelectProfessionPageState createState() => _SelectProfessionPageState();
}

class _SelectProfessionPageState extends State<SelectProfessionPage> {
  String selectedProfession;

  @override
  void initState() {
    super.initState();
    int r = Random().nextInt(Global.professions.keys.length);
    String initialProfession = Global.professions.keys.elementAt(r);
    changeProfession(initialProfession);
  }

  void changeProfession(String professionID) {
    selectedProfession = professionID;
    Global.setSelectedProfession(selectedProfession);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeef9bf),
      body: Center(
        child: Container(
          width: 320,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                      child: Text(
                        '(1/3)\n\nFirst, we need to know what is your current profession. Select one from the list or choose other.',
                        style: TextStyle(
                          color: Color(0xff6a8caf),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedProfession,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Color(0xff75b79e)),
                      underline: Container(
                        height: 2,
                        color: Color(0xff75b79e),
                      ),
                      onChanged: (String professionID) {
                        setState(() {
                          selectedProfession = professionID;
                          Global.setSelectedProfession(professionID);
                        });
                      },
                      items: Global.professions.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(Global.professions[value]),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xff75b79e),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuggestPage()));
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          color: Color(0xffeef9bf),
        ),
      ),
    );
  }
}

class SuggestPage extends StatefulWidget {
  @override
  _SuggestPageState createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeef9bf),
      body: Center(
        child: Container(
          width: 320,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                      child: Text(
                        '(2/3)\n\nMake a suggestions [in progress...]',
                        style: TextStyle(
                          color: Color(0xff6a8caf),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xff75b79e),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmPage()));
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          color: Color(0xffeef9bf),
        ),
      ),
    );
  }
}

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeef9bf),
      body: Center(
        child: Container(
          width: 320,
          height: 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: Text(
                      '(3/3)\n\nWe will now show you some job alternatives based on what other people with your same profession suggest.\n\nClick on 👍 up if you like it or 👎 if you don’t.\n\nThis will help our algorithm learn how to make better suggestions over time.',
                      style: TextStyle(
                        color: Color(0xff6a8caf),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Color(0xff75b79e),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecommendationsPage()));
                      },
                      child: Text(
                        'OK, See Suggestions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          color: Color(0xffeef9bf),
        ),
      ),
    );
  }
}

class RecommendationsPage extends StatefulWidget {
  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  Widget _animatedWidget;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _animatedWidget = _buildCard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Recommendations for ${Global.getSelectedProfessionTitle()}'),
        backgroundColor: Color(0xff75b79e),
      ),
      backgroundColor: Color(0xffeef9bf),
      body: Center(
        child: Container(
          width: 320,
          height: 400,
          child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  ScaleTransition(
                    child: child,
                    scale: animation,
                  ),
              switchInCurve: Curves.elasticIn,
              switchOutCurve: Curves.easeOut,
              duration: const Duration(milliseconds: 350),
              child: _animatedWidget),
          color: Color(0xffeef9bf),
        ),
      ),
    );
  }

  Card _buildCard() {
    Recommendation recommendation = Global.getNextRecommendation();
    return Card(
      key: ValueKey<int>(_count),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                '${recommendation.title}',
                style: TextStyle(
                    color: Color(0xff6a8caf),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 4),
              child: Text(
                '${recommendation.description}',
                style: TextStyle(
                  color: Color(0xff6a8caf),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xff75b79e),
                    textColor: Colors.white,
                    child: Text(
                      '👎',
                      style: TextStyle(fontSize: 56),
                    ),
                    onPressed: () {
                      setState(() {
                        _count += 1;
                        _animatedWidget = _buildCard();
                      });
                    },
                  ),
                  RaisedButton(
                    color: Color(0xff75b79e),
                    textColor: Colors.white,
                    child: Text(
                      '👍',
                      style: TextStyle(fontSize: 56),
                    ),
                    onPressed: () {
                      setState(() {
                        _count += 1;
                        _animatedWidget = _buildCard();
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
