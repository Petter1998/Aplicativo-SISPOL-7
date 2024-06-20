import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/reports/reports_model.dart';


class ReporteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('reporteId');
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

  Future<void> registerReporte(Map<String, dynamic> repoData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in repoData.keys) {
      if (repoData[key] == null || (repoData[key] is String && repoData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de orden de Mantenimiento
    int repoId = await _getNextDocId();

    await _firestore.collection('reportes').doc(repoId.toString()).set({
      'id': repoId,
      ...repoData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class ReportesController {
  final ReporteController reporteController = ReporteController();
  final CollectionReference reportCollection = FirebaseFirestore.instance.collection('reportes');

  Future<void> registerReporte(BuildContext context, Map<String, dynamic> repoData) async {
    try {
      await reporteController.registerReporte(repoData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registreportwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<List<Reportes>> fetchReporte() async {
    QuerySnapshot snapshot = await reportCollection.get();
    List<Reportes> reportes = snapshot.docs.map((doc) => Reportes.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    reportes.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return reportes;
  }

  Future<void> deleteReporte(int repoId) async {
    // Eliminar de Firestore
    await reportCollection.doc(repoId.toString()).delete();
  }

  Future<List<Reportes>> searchReporte(String query) async {
    QuerySnapshot snapshot = await reportCollection.where('reponsableEntrega', isEqualTo: query).get();
    List<Reportes> reportes = snapshot.docs.map((doc) => Reportes.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return reportes;
  }
}