import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(Map<String, dynamic> userData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in userData.keys) {
      if (userData[key] == null || (userData[key] is String && userData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Elimina la contraseña del mapa antes de enviarlo a Firestore
    

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: userData['email'],
      password: userData['password'],
    );

    // Elimina la contraseña del mapa antes de enviarlo a Firestore
    userData.remove('password');

    await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
      ...userData,
      'fechaCreacion': FieldValue.serverTimestamp(),
      'uid': userCredential.user!.uid,
    });
  }
}
