import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/models/administration/users/users_model.dart';

class UsersController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

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

  Future<void> registerUsers(BuildContext context, Map<String, dynamic> userData) async {
    try {
      // Verifica que todos los campos requeridos no estén vacíos
      for (String key in userData.keys) {
        if (userData[key] == null || (userData[key] is String && userData[key].isEmpty)) {
          throw Exception('El campo $key no puede estar vacío');
        }
      }

      // Guarda las credenciales del usuario actual
      auth.User? currentUser = _auth.currentUser;
      final auth.AuthCredential? credential = currentUser != null
          ? auth.EmailAuthProvider.credential(
              email: currentUser.email!,
              password: await getCurrentUserPassword(context), // Método para obtener la contraseña actual del usuario
            )
          : null;

      // Crea el nuevo usuario
      final String email = userData['email'];
      final String password = userData['password'];
      auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
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

      // Reautenticar al usuario actual
      if (credential != null) {
        await _auth.signInWithCredential(credential);
      }

      // Navegar a la pantalla de confirmación
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registwins');
    } catch (e) {
      // Mostrar mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<String> getCurrentUserPassword(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    String? password;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ingrese su contraseña de Administrador',
            style: GoogleFonts.inter(color: Colors.black),),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Contraseña',
            hintStyle: GoogleFonts.inter(color: Colors.black),),
          ),
          actions: [
            TextButton(
              onPressed: () {
                password = passwordController.text;
                Navigator.of(context).pop();
              },
              child: Text('Aceptar',
              style: GoogleFonts.inter(color: Colors.black),),
            ),
          ],
        );
      },
    );

    if (password == null || password!.isEmpty) {
      throw Exception('La contraseña es requerida para ejecutar la acción');
    }

    return password!;
  }
}

class UserController {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance; // Instancia de FirebaseAuth
  final UsersController usersController = UsersController();

  Future<List<User>> fetchUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    List<User> users = snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    users.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return users;
  }

  Future<void> updateUser(User user) async {
    await usersCollection.doc(user.uid).update(user.toMap());
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && firebaseUser.email != user.email) {
        // Actualizar el correo electrónico del usuario actual
        // ignore: deprecated_member_use
        await firebaseUser.updateEmail(user.email);
        // Enviar un correo electrónico de verificación si es necesario
        await firebaseUser.sendEmailVerification();

        // ignore: avoid_print
        print("Correo electrónico actualizado correctamente");
        }
    } catch (e) {
      // ignore: avoid_print
      print("Error al actualizar el email en FirebaseAuth: $e");
    }
  }

  Future<void> deleteUser(String uid) async {
    // Eliminar de Firestore
    await usersCollection.doc(uid).delete();

    // Eliminar de FirebaseAuth
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.delete();
    }

  }

  Future<List<User>> searchUsers(String query) async {
    QuerySnapshot snapshot = await usersCollection.where('nombres', isEqualTo: query).get();
    List<User> users = snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    // ignore: avoid_print
    print("Resultados de la búsqueda: ${users.length}"); // Añado esta línea para verificar
    return users;
  }
}