

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class PolivPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => PolivPageState();

}

class PolivPageState extends State<PolivPage> {
  var angle = .0;
  int get day {
    int res = (angle * 32 / (2 * math.pi)).round() + 1;
    return res < 0 ? res + 32 : res;
  }
  final krugKey = GlobalKey();

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
        Transform.rotate(
            angle: this.angle,
            child: Container(
                width: 250,
                height: 250,
                alignment: Alignment.topCenter,
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: -this.angle,
                        child: Text(
                          day.toString(),
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
        body: Column(
          children: <Widget>[
            Row(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){}
              ),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: (){}
              ),
            ],),
            Spacer(),
            Container(
              width: 250,
              height: 250,
              key: krugKey,
              child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTapDown: onTapDown,
                  onTapUp: onTapUp,
                  child: Stack(
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

                            }
                        )
                    )
                )
              ],
            ),
            Container(height:100)
          ],
        )
    );
  }
}