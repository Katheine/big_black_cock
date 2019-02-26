

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EvenMoreDetailsPage extends StatefulWidget {
  final String photoUrl;
  final String description;

  EvenMoreDetailsPage(this.photoUrl, this.description);

  @override
  State<StatefulWidget> createState() {
    return EvenMoreDetailsState(photoUrl, description);
  }

}

class EvenMoreDetailsState extends State<EvenMoreDetailsPage> {
  final String photoUrl;
  final String description;

  EvenMoreDetailsState(this.photoUrl, this.description);

  RichText makeSomethingJirnij(String text) {
    final splitted = text.split(" ");
    final spans = <TextSpan>[];
    splitted.forEach((part) {
      var doljnoBitJirnim = false;
      switch(part) {
        case "Влажность воздуха и полив":
        case "Пересадка":
        case "Удобренрие":
          doljnoBitJirnim = true;
      }
      spans.add(TextSpan(text: part, style: doljnoBitJirnim ? TextStyle(fontWeight: FontWeight.bold) : null));
    });
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
            Container(
              child: Image.network(photoUrl ?? "https://pbs.twimg.com/media/Dz7QjApXgAAjHtZ.jpg"),
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
                          onPressed: (){},
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
              Text("Произрастает", style: TextStyle(fontWeight: FontWeight.bold)),
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