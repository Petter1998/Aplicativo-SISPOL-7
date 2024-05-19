import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método modificado para obtener también el nombre de usuario
  Future<Map<String, dynamic>> verifyCedula(String cedula) async {
    if (cedula.isEmpty) {
      return {'exists': false};
    }

    try {
      var collection = _firestore.collection('usuarios');
      var querySnapshot = await collection.where('cedula', isEqualTo: cedula).get();
      if (querySnapshot.docs.isNotEmpty) {
        // 
        var userDoc = querySnapshot.docs.first;
        return {
          'exists': true,
          'usuario': userDoc.data()['usuario'] ?? 'Usuario desconocido'
        };
      }
      return {'exists': false};
    } catch (e) {
      return {'exists': false};
    }
  }

  Future<bool> changeUserPassword(String newPassword) async {
    if (newPassword.isEmpty) {
      return false;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword);
      return true; // Retornar verdadero si la contraseña se cambia correctamente.
    } catch (e) {
      return false; // Retornar falso si hay un error.
    }
  }

}