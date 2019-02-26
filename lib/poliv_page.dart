

import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class PolivPage extends StatefulWidget {
  final String name;

  PolivPage(this.name);

  @override
  State<StatefulWidget> createState() => PolivPageState(name);

}

class PolivPageState extends State<PolivPage> {
  var angle = .0;
  int get day {
    int res = (angle * 31 / (2 * math.pi)).round();
    return res < 0 ? res + 31 : res;
  }
  final krugKey = GlobalKey();
  final random = math.Random();
  int dayPoliv;
  int dayPeresadka;
  final String name;

  PolivPageState(this.name);

  @override
  initState() {
    super.initState();
    dayPoliv = random.nextInt(31);
    do {
      dayPeresadka = random.nextInt(31);
    } while((dayPoliv - dayPeresadka).abs() < 5);
  }

  onTapDown(TapDownDetails tdd) {
    handleDpadEvent(tdd.globalPosition);
  }

  onTapUp(TapUpDetails tud) {

  }

  void handleDpadEvent(Offset tapPoint) {
    final RenderBox renderObj = krugKey.currentContext.findRenderObject();
    final dpadPosition = renderObj.localToGlobal(Offset.zero);
    final relativeTapPoint = tapPoint - dpadPosition;
    final size = renderObj.size;
    if (relativeTapPoint.dx > size.width || relativeTapPoint.dy > size.height)
      return;
    final angle = math.atan2(
        size.height / 2 - relativeTapPoint.dy,
        relativeTapPoint.dx - (size.width / 2)
    ) - (math.pi / 2);
    setState((){
      this.angle = -angle;
    });
  }

  openProfilePage() async {
    final currUser = await FirebaseAuth.instance.currentUser();
    if (currUser == null) {
      Navigator.of(context).pushReplacementNamed('/auth');
    } else {
      Navigator.of(context).pushReplacementNamed("/profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    var stackChildren = <Widget>[];
    // Background
    stackChildren.add(Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFAE9E9),
          shape: BoxShape.circle
      ),
      padding: EdgeInsets.all(50),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
        ),
      ),
    ));
    stackChildren.add(
      Text(
        "День ${DateTime.now().day}",
        style: TextStyle(fontSize: 30, color: const Color(0xFF415e30)),
      )
    );
    for (var i = dayPoliv; i < dayPoliv + 5; i++) {
      stackChildren.add(
        Transform.rotate(
          angle: i * math.pi * 2 / 31,
          child: Container(
            width: 320,
            height: 320,
            alignment: Alignment.topCenter,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle
              ),
            )
          )
        )
      );
    }
    for (var i = dayPeresadka; i < dayPeresadka + 3; i++) {
      stackChildren.add(
        Transform.rotate(
          angle: i * math.pi * 2 / 31,
          child: Container(
            width: 320,
            height: 320,
            alignment: Alignment.topCenter,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.5),
                  shape: BoxShape.circle
              ),
            )
          )
        )
      );
    }
    stackChildren.add(
      Transform.rotate(
        angle: this.angle,
        child: Container(
          width: 320,
          height: 320,
          alignment: Alignment.topCenter,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7),
              shape: BoxShape.circle
            ),
            child: Center(
              child: Transform.rotate(
                angle: -this.angle,
                child: Text((day+1).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
              ),
            )
          )
        )
      )
    );
    return Scaffold(
      body: SafeArea(child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){ Navigator.of(context).pop(); },
            ),
            Spacer(),
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: openProfilePage,
            ),
          ],),
          Spacer(),
          Text(name),
          Spacer(),
          Container(
            width: 320,
            height: 320,
            key: krugKey,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTapDown: onTapDown,
              onTapUp: onTapUp,
              child: Stack(
                alignment: Alignment.center,
                children: stackChildren
              )
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFBABDDC),Color(0xFFFAE9E9)]),
                  ),
                  child: FlatButton(
                    child: Text(
                      "Установить напоминание",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed:(){
// Убейте меня
      //пожлуставыфаджлаьфаывождтфлы
                    }
                  )
                )
              )
            ],
          ),
          Container(height:100)
        ],
      ))
    );
  }
}