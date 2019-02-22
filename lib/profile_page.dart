

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }

}

class ProfilePageState extends State<ProfilePage> {
  String userPhotoUrl;
  String name;

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  asyncInitState() async {
    final user = await FirebaseAuth.instance.currentUser();
    userPhotoUrl = user.photoUrl;
    name = user.displayName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userPhotoUrl == null) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.network(
              userPhotoUrl,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0x11000000)
              ),
              child: Container(
                width: 1000,
                height: 1000,
                color: Colors.red.withOpacity(0.1),
                child: new BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    width: 1000,
                    height: 1000,
                    color: Colors.transparent,
                  )
                ),
              )
            )
          ),
          Positioned(
            top: 75,
            left: 30,
            height: 200,
            width: 200,
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(userPhotoUrl)
            ),
          ),
          Positioned(
            top: 75,
            left: 230,
            right: 30,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(name),
                Text("Суккуленты 5"),
                Text("Кактусы 5")
              ],
            )
          ),
          Positioned(
            top: 250,
            bottom: 30,
            left: 30,
            right: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text("Мои растения", style: TextStyle(fontSize: 30)),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("Избранное", style: TextStyle(fontSize: 30)),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("Настройки", style: TextStyle(fontSize: 30)),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("О Приложении", style: TextStyle(fontSize: 30)),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("Выйти из аккаунта", style: TextStyle(fontSize: 30)),
                )
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              iconSize: 20,
              icon: Icon(Icons.arrow_back),
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}