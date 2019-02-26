

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:succ/poliv_page.dart';

class EvenMoreDetailsPage extends StatefulWidget {
  final String photoUrl;
  final String description;
  final String name;

  EvenMoreDetailsPage(this.name, this.photoUrl, this.description);

  @override
  State<StatefulWidget> createState() {
    return EvenMoreDetailsState(name, photoUrl, description);
  }

}

class EvenMoreDetailsState extends State<EvenMoreDetailsPage> {
  final String photoUrl;
  final String description;
  final String name;
  var easterEggActivated = false;
  var eeTouches = 0;
  var lastTapTime = DateTime.now();

  EvenMoreDetailsState(this.name, this.photoUrl, this.description);

  final regex = RegExp(r"(\n[^:,.]+:)"); //Don't touch. Magic

  RichText makeSomethingJirnij(String text) {
    final spans = <TextSpan>[];
    Iterable<Match> matches = regex.allMatches(text);
    var j = 0;
    matches.forEach((m) {
      final partPre = text.substring(j, m.start);
      final part = text.substring(m.start, m.end);
      j = m.end;
      spans.add(TextSpan(text: partPre));
      spans.add(TextSpan(text: part, style: TextStyle(fontWeight: FontWeight.bold)));
    });
    spans.add(TextSpan(text: text.substring(j)));
    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: null,
    body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                if (DateTime.now().difference(lastTapTime) < Duration(milliseconds: 500)) {
                  if (eeTouches++ == 5) {
                    setState((){
                      easterEggActivated = true;
                    });
                  }
                } else {
                  eeTouches = 0;
                }
                lastTapTime = DateTime.now();
              },
              child: Container(
                child: Image.network(easterEggActivated ? "https://pbs.twimg.com/media/D0QJ1QBX4AE1lDe.jpg" : photoUrl),
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
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: (){
                          },
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
              makeSomethingJirnij(description),
              FlatButton(
                child: Text("Установить напоминание"),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return PolivPage(name);
                  }));
                },
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(0,0)),
                  onMapCreated: (_){},
                ),
              )
            ],
          ),
        )
      ],
    ),
  );

}