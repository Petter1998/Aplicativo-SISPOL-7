import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/reports/reports_model.dart';


class ReporteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función privada para obtener el próximo ID de reporte utilizando una transacción
  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('reporteId');
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

   // Función para registrar un nuevo reporte en Firestore
  Future<void> registerReporte(Map<String, dynamic> repoData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in repoData.keys) {
      if (repoData[key] == null || (repoData[key] is String && repoData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de orden de Mantenimiento
    int repoId = await _getNextDocId();

    // Guardar el nuevo reporte en Firestore con la fecha de creación
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

  // Función para registrar un nuevo reporte y navegar a la página de éxito
  Future<void> registerReporte(BuildContext context, Map<String, dynamic> repoData) async {
    try {
      await reporteController.registerReporte(repoData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registreportwins'); 
    } catch (e) {
      // Mostrar un mensaje de error si hay un problema al registrar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  // Función para obtener la lista de reportes desde Firestore
  Future<List<Reportes>> fetchReporte() async {
    QuerySnapshot snapshot = await reportCollection.get();
    List<Reportes> reportes = snapshot.docs.map((doc) => Reportes.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    reportes.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return reportes;
  }

  // Función para eliminar un reporte de Firestore
  Future<void> deleteReporte(int repoId) async {
    // Eliminar de Firestore
    await reportCollection.doc(repoId.toString()).delete();
  }

  // Función para buscar reportes por el campo 'reponsableEntrega'
  Future<List<Reportes>> searchReporte(String query) async {
    QuerySnapshot snapshot = await reportCollection.where('responsableEntrega', isEqualTo: query).get();
    List<Reportes> reportes = snapshot.docs.map((doc) => Reportes.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return reportes;
  }
}