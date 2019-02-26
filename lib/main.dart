import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:succ/auth_page.dart';
import 'package:succ/details_page.dart';
import 'package:succ/poliv_page.dart';
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

  var isSucc = true;
  String get type => isSucc ? "succ" : "cactus";

  @override
  initState() {
    super.initState();
    newFutures();
  }

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
                    color: isSucc ? Colors.green : Colors.white,
                    onPressed: () {
                      setState(() {
                        newFutures();
                        isSucc=true;
                      } );
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cannabis),
                    color: isSucc ? Colors.white : Colors.green,
                    onPressed: () {
                      setState(() {
                        newFutures();
                        isSucc=false;
                      } );
                    },
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
      body: getPage(context)
    );
  }

  newFutures() {
    for (var i = 0; i <= SUCC_COUNT; i++) {
      futuresImages[i] = loadPic(i);
      futuresTexts[i] = loadText(i);
    }
  }

  static var SUCC_COUNT = 5;
  final futuresImages = List<Future<Image>>(10);
  final futuresTexts = List<Future<String>>(10);
  final pageController = PageController();

  @override
  Widget getPage(BuildContext context) =>
      Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    isSucc ? "Succulentu" : "Хуяктусы",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 27
                    ),
                  ),
                  Text(
                    isSucc ? "Суккуленты — растения, имеющие специальные ткани для запаса воды." : "Хуяктусы",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14) ,
                  ),
                  Expanded(
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: SUCC_COUNT,
                        itemBuilder: (_, num) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: FutureBuilder<Image>(
                                  future: futuresImages[num],
                                  builder: (_, ass) =>
                                  ass.data ?? CircularProgressIndicator(),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: ListView(
                                  children: <Widget>[
                                    Center(
                                      child: FutureBuilder<String>(
                                        future: futuresTexts[num],
                                        builder: (_, ass) => Text(ass.data) ?? CircularProgressIndicator(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                    ),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFFBCD5C1),Color(0xFF5D9D67)]),
                          ),
                          child:FlatButton(
                            child: Text(
                              " Узнать больше ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                            onPressed: () async {
                              final num = pageController.page.toInt();
                              final txt = await futuresTexts[num];
                              final name = txt.split(" ")[0]; // ы
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return DetailsPage(num, type);
                              }));
                            },
                          )
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Future<Image> loadPic(int num) async {
    var cactusRef = FirebaseStorage.instance.ref().child("/$type/$num.jpg");
    var downloadUrl = await cactusRef.getDownloadURL();
    return Image.network(downloadUrl);
  }

  Future<String> loadText (int num) async {
    var descriptionRef = FirebaseDatabase.instance.reference().child("$type/$num");
    var snap = await descriptionRef.once();
    print(snap.value);
    var name = snap.value["name"];
    var desc = snap.value["desc"];
    return "$name \n $desc";
  }
}
