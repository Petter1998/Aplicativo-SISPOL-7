import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/users/users_model.dart';


class UsersController {
  final UsersModel usersModel = UsersModel();

  Future<void> registerUsers(BuildContext context, Map<String, dynamic> userData) async {
    try {
      await usersModel.registerUsers(userData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }
}

class UserController {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance; // Instancia de FirebaseAuth

  Future<List<User>> fetchUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    List<User> users = snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    users.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return users;
  }

  Future<void> addUser(User user) async {
    await usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(User user) async {
    try {
      await usersCollection.doc(user.uid).update(user.toMap());
      // ignore: avoid_print
      print("Usuario actualizado correctamente en Firestore: ${user.uid}");
    } catch (e) {
      // ignore: avoid_print
      print("Error al actualizar el usuario en Firestore: $e");
    }
  }

  Future<void> updateUserEmail(String uid, String newEmail) async {
    try {
      auth.User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        // ignore: deprecated_member_use
        await currentUser.updateEmail(newEmail);
        // ignore: avoid_print
        print("Correo electrónico actualizado correctamente en FirebaseAuth");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error al actualizar el correo de FirebaseAuth: $e");
    }
  }

  Future<void> deleteUser(String uid) async {
    // Eliminar de Firestore
    await usersCollection.doc(uid).delete();

    // Eliminar de FirebaseAuth
    try {
      auth.User? user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error al eliminar usuario de FirebaseAuth: $e");
    }
  }
}