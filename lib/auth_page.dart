

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AuthPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => AuthPageState();

}

class AuthPageState extends State<AuthPage> {

  googleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email',],
    );
    final googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children:[
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.googlePlusG),
                  onPressed: googleSignIn,
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter),
                  onPressed: (){},
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebookF),
                  onPressed: (){},
                )
              ]
            )
          ],
        )
      ]
    ),
  );

}