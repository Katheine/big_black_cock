

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:succ/even_more_details.dart';

class DetailsPage extends StatefulWidget {
  final int num;
  final String type;

  DetailsPage(this.num, this.type);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsState(num, type);
  }

}

class DetailsState extends State<DetailsPage> {
  final int num;
  final String type;
  Future<dynamic> urlImage;
  Future<DataSnapshot> futureData;

  DetailsState(this.num, this.type);

  openProfilePage() async {
    final currUser = await FirebaseAuth.instance.currentUser();
    if (currUser == null) {
      Navigator.of(context).pushNamed('/auth');
    } else {
      Navigator.of(context).pushNamed("/profile");
    }
  }

  @override
  void initState() {
    super.initState();
    var cactusRef = FirebaseStorage.instance.ref().child("/succ/${num+1}.jpg");
    print(num);
    urlImage = cactusRef.getDownloadURL();
    futureData = FirebaseDatabase.instance.reference().child("succ_info/$num").once();
  }

  Widget buildData(BuildContext ctx, AsyncSnapshot<DataSnapshot> snap) {
    if (snap.data == null)
      return Stack(fit: StackFit.expand);
    final desc = snap.data.value["info"];
    final widgetsList = <Widget>[
      Text(
        type,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
      Text(
        desc,
        textAlign: TextAlign.justify,
      ),
      Text(
        "Разновидности:",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    ];
    List podvidi = snap.data.value["subs"];
    for (var i = 0; i < podvidi.length; i++) {
      final element = podvidi[i];
      widgetsList.add(
        FlatButton(
          onPressed: () {
            final desc = element['desc'];
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return EvenMoreDetailsPage(null, desc);
            }));
          },
          child: Row(
            children: <Widget>[
              Container(width: 35, height: 35, color: Colors.red),
              Text(element['name']),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          )
        )
      );
    }
    return ListView(
      padding: EdgeInsets.all(10),
      children: widgetsList,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: null,
    body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: FutureBuilder(
                  future: urlImage,
                  builder: (_,as){
                    if (as.data == null) {
                      return CircularProgressIndicator();
                    } else {
                      print(as.data);
                      return Image.network(as.data);
                    }
                  } ,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x44000000)
                ),
                child: Container(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      color: const Color(0xFFFFFFFF).withOpacity(0.01),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: ( ){ Navigator.of(context).pop(); },
                          ),
                          Spacer(),
                          Text(
                            type,
                            style: TextStyle( color: Colors.white ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: openProfilePage,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: futureData,
              builder: buildData,
            )
          ),
        ],
      ),
  );

}