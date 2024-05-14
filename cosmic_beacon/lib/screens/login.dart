import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:cosmic_beacon/models/shooting_stars.dart';
import 'package:cosmic_beacon/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localization/localization.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Future<UserCredential?> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      OAuthCredential credential;
      try {
        // Create a new credential
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
      } catch (e) {
        return null;
      }

      var userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Database(uid: userCred.user!.uid).createUser();
      return userCred;
    }

    return Scaffold(
        body: Stack(children: [
      const ShootingStarsBackground(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'login-start-text'.i18n(),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 32),
              GlassButton(
                  borderRadius: 10,
                  child: SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("lib/res/img/google.png",
                              width: 24, height: 24),
                          const SizedBox(width: 8),
                          Text("login-google".i18n())
                        ],
                      )),
                  onPressed: () {
                    signInWithGoogle().then((value) {
                      if (value != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).highlightColor.withAlpha(50),
                          content: Text("login-success".i18n(),
                              style: const TextStyle(color: Colors.white)),
                        ));
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).highlightColor.withAlpha(50),
                          content: Text("login-failed".i18n(),
                              style: const TextStyle(color: Colors.white)),
                        ));
                      }
                    });
                  }),
            ],
          ),
        ),
      ),
    ]));
  }
}
