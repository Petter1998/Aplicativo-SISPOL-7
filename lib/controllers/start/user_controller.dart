import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/start/user_model.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> _getNextUserId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('usuarioId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1;
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

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

    // Obtener el próximo ID de usuario
    int userId = await _getNextUserId();

    await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
      'id': userId,
      ...userData,
      'fechaCreacion': FieldValue.serverTimestamp(),
      'uid': userCredential.user!.uid,
    });
  }
}

class UserController {
  final UserModel userModel = UserModel();

  Future<void> registerUser(BuildContext context, Map<String, dynamic> userData) async {
    try {
      await userModel.registerUser(userData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registwin'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }
}


class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Usuario?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (userDoc.exists) {
          return Usuario.fromFirestore(userDoc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting current user: $e');
    }
    return null;
  }
}

