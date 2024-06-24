import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? currentUserRole;

  Future<bool> login(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      await _getUserRole(uid);
      // ignore: avoid_print
      print('Login successful');
      return true;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Login failed: ${e.message}');
      return false;
    }
  }

  Future<void> _getUserRole(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    if (userDoc.exists) {
      currentUserRole = userDoc['cargo'];
      // ignore: avoid_print
      print('User role: $currentUserRole');
    }
  }

  //Future<bool> loginWithGoogle() async {
    //try {
      //final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //if (googleUser != null) {
        //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        //final AuthCredential credential = GoogleAuthProvider.credential(
         // accessToken: googleAuth.accessToken,
          //idToken: googleAuth.idToken,
        ///);

        // ignore: unused_local_variable
       // final UserCredential userCredential = await _auth.signInWithCredential(credential);
        // ignore: avoid_print
       // print('Login with Google successful');
       // return true;
     // }
     // return false;
   // } catch (e) {
     // // ignore: avoid_print
     // print('Login with Google failed: ${e.toString()}');
     // return false;
   // }
 // }
}
