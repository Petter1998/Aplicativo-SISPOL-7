import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> login(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: avoid_print
      print('Login successful');
      return true;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Login failed: ${e.message}');
      return false;
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
