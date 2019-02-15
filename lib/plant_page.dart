import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:succ/details_page.dart';

class PlantPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlantPageState();
  }

}

class PlantPageState extends State<PlantPage> {

  static var SUCC_COUNT = 5;
  final futuresImages = List<Future<Image>>(10);
  final futuresTexts = List<Future<String>>(10);
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    for (var i = 1; i <= SUCC_COUNT; i++) {
      futuresImages[i] = loadPic(i);
      futuresTexts[i] = loadText(i);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Succulentu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        fontSize: 27
                    ),
                  ),
                  Text("a tut text"),
                  Expanded(
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: SUCC_COUNT,
                        itemBuilder: (_, num) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: FutureBuilder<Image>(
                                  future: futuresImages[num+1],
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
                                          future: futuresTexts[num+1],
                                          builder: (_, ass) =>
                                          Text(ass.data) ?? CircularProgressIndicator(),
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
                  RaisedButton(
                    child: Text(
                      "Uznat bolshe",
                      style: TextStyle(
                          color: const Color(0xFFFFFFFF)
                      ),
                    ),
                    color: Colors.teal,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        final num = pageController.page.toInt();
                        return DetailsPage(num + 1 , 'succ');
                      }));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );

  static Future<Image> loadPic(int num) async {
    var cactusRef = FirebaseStorage.instance.ref().child("/succ/$num.jpg");
    var downloadUrl = await cactusRef.getDownloadURL();
    return Image.network(downloadUrl);
  }

  static Future<String> loadText (int num) async{
    var descriptionRef = FirebaseDatabase.instance.reference().child("succ/$num");
    var snap = await descriptionRef.once();
    var name = snap.value["name"];
    var desc = snap.value["desc"];
    return "$name \n $desc";
  }
}