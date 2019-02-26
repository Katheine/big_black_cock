import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:succ/even_more_details.dart';
import 'package:succ/mini_photo_future_list.dart';

class DetailsPage extends StatefulWidget {
  final int num;
  final String type;

  DetailsPage(this.num, this.type);

  @override
  State<StatefulWidget> createState() {
    return DetailsState(num, type);
  }

}

class DetailsState extends State<DetailsPage> {
  final int num;
  final String type;
  Future<dynamic> urlImage;
  Future<DataSnapshot> futureData;
  MiniPhotoFutureList miniPhotoFutures;
  var title = "";

  DetailsState(this.num, this.type) {
    miniPhotoFutures = MiniPhotoFutureList(num, type);
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
  void initState() {
    super.initState();
    var cactusRef = FirebaseStorage.instance.ref().child("/${type}_info/$num/info/$num.jpg");
    print(num);
    urlImage = cactusRef.getDownloadURL();
    futureData = FirebaseDatabase.instance.reference().child("${type}_info/$num").once();
  }

  Widget buildData(BuildContext ctx, AsyncSnapshot<DataSnapshot> snap) {
    if (snap.data == null)
      return Stack(fit: StackFit.expand);
    final desc = snap.data.value["info"];
    final imechko = desc.split(" ")[0];
    title = imechko;
    final widgetsList = <Widget>[
      Text(
        imechko,
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
          onPressed: () async {
            final desc = element['desc'];
            final name = element['name'];
            final url = await miniPhotoFutures[i];
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return EvenMoreDetailsPage(name, url, desc);
            }));
          },
          child: Row(
            children: <Widget>[
              FutureBuilder(
                future: miniPhotoFutures[i],
                builder: (ctx, snap) => snap.data != null ? CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(snap.data)
                ) : Container(height: 35, width: 35),
              ),
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
                            onPressed: () { Navigator.of(context).pop(); },
                          ),
                          Spacer(),
                          Text(
                            title,
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