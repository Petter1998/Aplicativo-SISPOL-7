import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/contratos/contrato_model.dart';

class ContratoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene el siguiente ID disponible para un nuevo contrato
  Future<int> _getNextDepId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('contratoId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      // Incrementa el ID actual en 1 y actualiza el documento
      int newId = snapshot['currentId'] + 1;
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

  // Registra un nuevo contrato en Firestore
  Future<void> registerContrato(Map<String, dynamic> contData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in contData.keys) {
      if (contData[key] == null || (contData[key] is String && contData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de contrato
    int contId = await _getNextDepId();

    // Guarda el contrato en Firestore con la fecha de creación actual
    await _firestore.collection('contratos').doc(contId.toString()).set({
      'id': contId,
      ...contData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class ContratosController {
  final ContratoController contratoController = ContratoController();

  // Registra un nuevo contrato y navega a la pantalla de éxito
  Future<void> registerContrato(BuildContext context, Map<String, dynamic> contData) async {
    try {
      await contratoController.registerContrato(contData);
      // Navega a la pantalla de contratos registrados
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registcontpwins'); 
    } catch (e) {
      // Muestra un mensaje de error si ocurre algún problema
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference contCollection = FirebaseFirestore.instance.collection('contratos');

  // Obtiene una lista de todos los contratos desde Firestore
  Future<List<Contrato>> fetchContrato() async {
    QuerySnapshot snapshot = await contCollection.get();
    List<Contrato> contratos = snapshot.docs.map((doc) => Contrato.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    // Ordena los contratos en orden descendente por ID
    contratos.sort((a, b) => b.id.compareTo(a.id)); // Ordena en orden descendente por id
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

  // Busca contratos en Firestore cuyo nombre coincida con la consulta dada
  Future<List<Contrato>> searchContrato(String query) async {
    QuerySnapshot snapshot = await contCollection.where('nombreContrato', isEqualTo: query).get();
    List<Contrato> contratos = snapshot.docs.map((doc) => Contrato.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return contratos;
  }
}