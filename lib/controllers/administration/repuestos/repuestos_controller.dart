import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/repuestos/repuestos_model.dart';

class RepuestoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDepId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('repuestoId');
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

  Future<void> registerRepuesto(Map<String, dynamic> repData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in repData.keys) {
      if (repData[key] == null || (repData[key] is String && repData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int repId = await _getNextDepId();

    await _firestore.collection('repuestos').doc(repId.toString()).set({
      'id': repId,
      ...repData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class RepuestosController {
  final RepuestoController repuestoController = RepuestoController();

  Future<void> registerRepuesto(BuildContext context, Map<String, dynamic> repData) async {
    try {
      await repuestoController.registerRepuesto(repData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registrepwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference repCollection = FirebaseFirestore.instance.collection('repuestos');

  Future<List<Repuesto>> fetchRepuesto() async {
    QuerySnapshot snapshot = await repCollection.get();
    List<Repuesto> repuestos = snapshot.docs.map((doc) => Repuesto.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    repuestos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return repuestos;
  }

  Future<void> updateRepuesto(Repuesto repuesto) async {
    try {
      await repCollection.doc(repuesto.id.toString()).update(repuesto.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el repuesto: $e');
    }
  }

  Future<void> deleteRepuesto(int repId) async {
    // Eliminar de Firestore
    await repCollection.doc(repId.toString()).delete();
  }

  Future<List<Repuesto>> searchRepuestos(String query) async {
    QuerySnapshot snapshot = await repCollection.where('nombre', isEqualTo: query).get();
    List<Repuesto> repuestos = snapshot.docs.map((doc) => Repuesto.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return repuestos;
  }
}