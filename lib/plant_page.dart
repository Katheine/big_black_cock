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
    for (var i = 0; i <= SUCC_COUNT; i++) {
      futuresImages[i] = loadPic(i+1);
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
                        color: Colors.white,
                        fontSize: 27
                    ),
                  ),
                  Text(
                    "Суккуленты — растения, имеющие специальные ткани для запаса воды.",
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
                              return DetailsPage(num, name);
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