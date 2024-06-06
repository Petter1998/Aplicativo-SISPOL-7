import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/user_model.dart';


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

