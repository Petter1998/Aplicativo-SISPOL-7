import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/documents/documents_model.dart';

class DocumentosController1 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función privada para obtener el próximo ID de documento utilizando una transacción
  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('documentoId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        // Si el documento no existe, inicializar el contador
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1; // Incrementar el ID actual
      transaction.update(counterRef, {'currentId': newId}); // Actualizar el contador en la base de datos
      return newId;
    });
  }

  // Función para registrar un nuevo documento en Firestore
  Future<void> registerDoc(Map<String, dynamic> docuData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in docuData.keys) {
      if (docuData[key] == null || (docuData[key] is String && docuData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de orden de Mantenimiento
    int docuId = await _getNextDocId();

    // Guardar el nuevo documento en Firestore con la fecha de creación
    await _firestore.collection('documentos').doc(docuId.toString()).set({
      'id': docuId,
      ...docuData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class DocumentosController2 {
  final DocumentosController1 documentosController1 = DocumentosController1();
  final CollectionReference ordenCollection = FirebaseFirestore.instance.collection('documentos');

  // Función para registrar un nuevo documento y navegar a otra pantalla en caso de éxito
  Future<void> registerDoc(BuildContext context, Map<String, dynamic> docuData) async {
    try {
      await documentosController1.registerDoc(docuData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        // ignore: use_build_context_synchronously
        context, 
        '/registdocwins',
        arguments: docuData, // Pasando los datos a través de las rutas
      ); 
    } catch (e) {
      // Mostrar un mensaje de error si hay un problema al registrar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  // Función para obtener la lista de documentos desde Firestore
  Future<List<Documentos>> fetchDocumentos() async {
    QuerySnapshot snapshot = await ordenCollection.get();
    List<Documentos> documentos = snapshot.docs.map((doc) => Documentos.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    // Ordenar por el campo "estado" en orden ascendente
    documentos.sort((a, b) => a.estado.compareTo(b.estado));

    return documentos;
  }

  // Función para eliminar un documento de Firestore
  Future<void> deleteDoc(int docuId) async {
    // Eliminar de Firestore
    await ordenCollection.doc(docuId.toString()).delete();
  }

  // Función para buscar documentos por el campo "placa"
  Future<List<Documentos>> searchDoc(String query) async {
    QuerySnapshot snapshot = await ordenCollection.where('placa', isEqualTo: query).get();
    List<Documentos> documentos = snapshot.docs.map((doc) => Documentos.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return documentos;
  }
}