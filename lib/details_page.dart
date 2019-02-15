

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

  DetailsState(this.num, this.type);

  openProfilePage() async {
    final currUser = await FirebaseAuth.instance.currentUser();
    if (currUser == null) {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  void initState() {
    super.initState();
    var cactusRef = FirebaseStorage.instance.ref().child("/succ/$num.jpg");
    print(num);
    urlImage = cactusRef.getDownloadURL();
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
                            "qwertgy",
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
            child: ListView(
              children: <Widget>[
                Text("sw4edrftyuhiji"),
                Text("Анакампсерос - многолетники, имеют формы трав или кустарников, обычно низкорослые. Относится представитель «возвращающих любовь» растений к известному семейству Портулаковые и являет собой миниатюрный суккулент.род Анакампсерос классифицируют на три подрода."),
                Text("Разновидности:"),
                InkWell(
                  onTap: () {

                  },
                  child: Row(
                    children: <Widget>[
                      Text("sdaougsahufiuhsfliusad",
                      style: TextStyle(fontSize: 30))
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[

                  ],
                )
              ],
            )
          ),
        ],
      ),
  );

}