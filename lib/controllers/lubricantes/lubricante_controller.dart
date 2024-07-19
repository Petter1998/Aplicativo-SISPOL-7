import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/lubricantes/lubricantes_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LubricanteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextLubricanteId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('lubricanteId');
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

  Future<void> registerLubricante(BuildContext context, Map<String, dynamic> lubData) async {
    try {
      // Obtener el usuario actual
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No se encontró al usuario actual.');
      }

      // Obtener el documento del usuario actual para extraer el ID
      DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        throw Exception('El documento del usuario no existe.');
      }

      // Extraer el ID del usuario desde el documento
      int idUser = userDoc.get('id');

      // Verificar que todos los campos requeridos no estén vacíos
      for (String key in lubData.keys) {
        if (lubData[key] == null || (lubData[key] is String && lubData[key].isEmpty)) {
          throw Exception('El campo $key no puede estar vacío');
        }
      }

      // Obtener el próximo ID de lubricante
      int lubId = await _getNextLubricanteId();

      await _firestore.collection('lubricantes').doc(lubId.toString()).set({
        'id': lubId,
        'idUser': idUser, // Agregar el ID del usuario actual
        ...lubData,
        'fechaIngreso': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registlubwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference lubCollection = FirebaseFirestore.instance.collection('lubricantes');

  Future<List<Lubricante>> fetchLubricantes() async {
    QuerySnapshot snapshot = await lubCollection.get();
    List<Lubricante> lubricantes = snapshot.docs.map((doc) => Lubricante.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    lubricantes.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return lubricantes;
  }

  Future<void> updateLubricante(Lubricante lubricante) async {
    try {
      await lubCollection.doc(lubricante.id.toString()).update(lubricante.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el lubricante: $e');
    }
  }

  Future<void> deleteLubricante(int lubId) async {
    // Eliminar de Firestore
    await lubCollection.doc(lubId.toString()).delete();
  }

  Future<List<Lubricante>> searchLubricantes(String query) async {
    QuerySnapshot snapshot = await lubCollection.where('nombre', isEqualTo: query).get();
    List<Lubricante> lubricantes = snapshot.docs.map((doc) => Lubricante.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return lubricantes;
  }
}
