import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/documents/documents_model.dart';

class DocumentosController1 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('documentoId');
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

  Future<void> registerDoc(Map<String, dynamic> docuData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in docuData.keys) {
      if (docuData[key] == null || (docuData[key] is String && docuData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de orden de Mantenimiento
    int docuId = await _getNextDocId();

    await _firestore.collection('documentos').doc(docuId.toString()).set({
      'id': docuId,
      ...docuData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class DocumentosController2 {
  final DocumentosController1 documentosController1 = DocumentosController1();
  final CollectionReference ordenCollection = FirebaseFirestore.instance.collection('ordenes_trabajo');

  Future<void> registerDoc(BuildContext context, Map<String, dynamic> docuData) async {
    try {
      await documentosController1.registerDoc(docuData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registdocwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<List<Documentos>> fetchDocumentos() async {
    QuerySnapshot snapshot = await ordenCollection.get();
    List<Documentos> documentos = snapshot.docs.map((doc) => Documentos.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    documentos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return documentos;
  }

  Future<void> deleteDoc(int docuId) async {
    // Eliminar de Firestore
    await ordenCollection.doc(docuId.toString()).delete();
  }

  Future<List<Documentos>> searchDoc(String query) async {
    QuerySnapshot snapshot = await ordenCollection.where('placa', isEqualTo: query).get();
    List<Documentos> documentos = snapshot.docs.map((doc) => Documentos.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return documentos;
  }
}