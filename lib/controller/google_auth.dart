import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_noteapp/views/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection("users");

void saveString(String value, String gmailVal, String dispName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('photo', value);

  prefs.setString('gmail', gmailVal);

  prefs.setString('displayName', dispName);
}

///
//Auth Function
///
Future<bool?> signInWithGoogle(BuildContext context) async {
  try {
    //
    //
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    //
    //
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      //
      //
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      //
      //
      final UserCredential authResult =
          await auth.signInWithCredential(authCredential);
      //
      //
      final User user = authResult.user!;
      //
      //
      var userData = {
        //the data of user's account needed to store on firebase
        "name": googleSignInAccount.displayName,
        "provider": 'google',
        'photourl': googleSignInAccount.photoUrl,
        "email": googleSignInAccount.email,
      };
      //
      //

      users.doc(user.uid).get().then((doc) {
        if (doc.exists) {
          saveString(
              googleSignInAccount.photoUrl!,
              googleSignInAccount.email.toString(),
              googleSignInAccount.displayName.toString());
          //if user already exists
          doc.reference.update(userData);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        } else {
          // saveString(
          //     googleSignInAccount.photoUrl!,
          //     googleSignInAccount.email.toString(),
          //     googleSignInAccount.displayName.toString());
          users.doc(user.uid).set(
              userData); //if there's no existing user with this email address
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        }
      });
    }
  } catch (PlatformExeception) {
    if (kDebugMode) {
      print(PlatformExeception);
    }
    if (kDebugMode) {
      print("SignIn not succesful");
    }
  }
  return null;
}
