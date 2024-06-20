import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/contratos/contrato_model.dart';

class ContratoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDepId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('contratoId');
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

  Future<void> registerContrato(Map<String, dynamic> contData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in contData.keys) {
      if (contData[key] == null || (contData[key] is String && contData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int contId = await _getNextDepId();

    await _firestore.collection('contratos').doc(contId.toString()).set({
      'id': contId,
      ...contData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class ContratosController {
  final ContratoController contratoController = ContratoController();

  Future<void> registerContrato(BuildContext context, Map<String, dynamic> contData) async {
    try {
      await contratoController.registerContrato(contData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registcontpwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference contCollection = FirebaseFirestore.instance.collection('contratos');

  Future<List<Contrato>> fetchContrato() async {
    QuerySnapshot snapshot = await contCollection.get();
    List<Contrato> contratos = snapshot.docs.map((doc) => Contrato.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    contratos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return contratos;
  }

  Future<void> updateContrato(Contrato contrato) async {
    try {
      await contCollection.doc(contrato.id.toString()).update(contrato.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el Contrato: $e');
    }
  }

  Future<void> deleteContrato(int contId) async {
    // Eliminar de Firestore
    await contCollection.doc(contId.toString()).delete();
  }

  Future<List<Contrato>> searchContrato(String query) async {
    QuerySnapshot snapshot = await contCollection.where('nombreContrato', isEqualTo: query).get();
    List<Contrato> contratos = snapshot.docs.map((doc) => Contrato.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return contratos;
  }
}