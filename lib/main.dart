import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:succ/auth_page.dart';
import 'package:succ/plant_page.dart';
import 'package:succ/poliv_page.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:succ/profile_page.dart';

void main() async {
  //await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/auth': (_) => AuthPage(),
        '/poliv': (_) => PolivPage(),
        '/profile': (_) => ProfilePage(),
      },
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
        primarySwatch: Colors.red,
        brightness: Brightness.dark
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  openProfilePage() async {
    final currUser = await FirebaseAuth.instance.currentUser();
    if (currUser == null) {
      Navigator.of(context).pushNamed('/auth');
    } else {
      Navigator.of(context).pushNamed("/profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => print("Search !!!!!")
            ),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cannabis),
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cannabis),
                    onPressed: () => Navigator.of(context).pushNamed('/poliv'),
                  ),
                  Spacer(),
                ]
              ),
            ),
            IconButton(
              icon: Icon(Icons.menu),
//              onPressed: openProfilePage
              onPressed: () => Navigator.of(context).pushNamed('/poliv'),
            )
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.3),
      ),
        backgroundColor: Colors.transparent,
      body: PlantPage()
    );
  }
}
