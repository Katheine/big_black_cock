

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
      scopes: ['email'],
    );
    final googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    if (user != null) {
      Navigator.of(context).pushReplacementNamed("/profile");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children:[

        Column(
          children: <Widget>[
            Row(
              children:[
                IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white,),
                    onPressed: (){ Navigator.of(context).pop(); }
                )
              ],
            ),
            Container(
              height: 250,
              width: 250,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.googlePlusG,
                      size: 80,
                    ),
                    iconSize: 80,
                    onPressed: googleSignIn,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      size: 80,
                    ),
                    iconSize: 80,
                    onPressed: (){},
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.facebookF,
                      size: 80,
                    ),
                    iconSize: 80,
                    onPressed: (){},
                  ),
                  Spacer()
                ]
            )

          ],
        )
      ]
    ),
  );
}