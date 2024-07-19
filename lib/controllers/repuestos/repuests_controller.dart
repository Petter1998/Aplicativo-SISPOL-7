import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/repuestos/repuest_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class RepuestoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextRepuestoId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('repuestId');
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

  Future<void> registerRepuesto(BuildContext context, Map<String, dynamic> reData) async {
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
      for (String key in reData.keys) {
        if (reData[key] == null || (reData[key] is String && reData[key].isEmpty)) {
          throw Exception('El campo $key no puede estar vacío');
        }
      }

      // Obtener el próximo ID de repuesto
      int reId = await _getNextRepuestoId();

      await _firestore.collection('repuesto').doc(reId.toString()).set({
        'id': reId,
        'idUser': idUser, // Agregar el ID del usuario actual
        ...reData,
        'fechaIngreso': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registreptpwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference reptCollection = FirebaseFirestore.instance.collection('repuesto');

  Future<List<Repuest>> fetchRepuestos() async {
    QuerySnapshot snapshot = await reptCollection.get();
    List<Repuest> repuestos = snapshot.docs.map((doc) => Repuest.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    repuestos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return repuestos;
  }

  Future<void> updateRepuesto(Repuest repuesto) async {
    try {
      await reptCollection.doc(repuesto.id.toString()).update(repuesto.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el repuesto: $e');
    }
  }

  Future<void> deleteRepuesto(int repId) async {
    // Eliminar de Firestore
    await reptCollection.doc(repId.toString()).delete();
  }

  Future<List<Repuest>> searchRepuestos(String query) async {
    QuerySnapshot snapshot = await reptCollection.where('nombre', isEqualTo: query).get();
    List<Repuest> repuestos = snapshot.docs.map((doc) => Repuest.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return repuestos;
  }
}

