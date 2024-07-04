import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ValidationController {
  final TextEditingController identiController = TextEditingController();

  Future<Map<String, dynamic>?> validatePerson(BuildContext context) async {
    String input = identiController.text.trim();
    bool isValid = false;
    DocumentSnapshot<Map<String, dynamic>>? personalDoc;

    // Verificar si el input es un número de cédula
    if (RegExp(r'^\d+$').hasMatch(input)) {
      int cedula = int.parse(input); // Convertir el input a int
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('personal')
          .where('cedula', isEqualTo: cedula)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        isValid = true;
        personalDoc = querySnapshot.docs.first;
        // ignore: avoid_print
        print('Documento personal encontrado: ${personalDoc.data()}');
      }
    } else {
      // Verificar si el input son dos nombres
      List<String> nombres = input.split(' ');
      if (nombres.length >= 2) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('personal')
            .where('nombres', isEqualTo: input)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          isValid = true;
          personalDoc = querySnapshot.docs.first;
          // ignore: avoid_print
          print('Documento personal encontrado: ${personalDoc.data()}');
        }
      }
    }

    if (isValid && personalDoc != null) {
      String nombreCompleto = "${personalDoc['nombres'].trim()} ${personalDoc['apellidos'].trim()}";
      // ignore: avoid_print
      print('Nombre completo: $nombreCompleto');

     QuerySnapshot<Map<String, dynamic>> vehicleSnapshot = await FirebaseFirestore.instance
          .collection('vehiculos')
          .where('responsable1', isEqualTo: nombreCompleto)
          .get();

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await FirebaseFirestore.instance
            .collection('vehiculos')
            .where('responsable2', isEqualTo: nombreCompleto)
            .get();
      }

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await FirebaseFirestore.instance
            .collection('vehiculos')
            .where('responsable3', isEqualTo: nombreCompleto)
            .get();
      }

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await FirebaseFirestore.instance
            .collection('vehiculos')
            .where('responsable4', isEqualTo: nombreCompleto)
            .get();
      }

      if (vehicleSnapshot.docs.isNotEmpty) {
        return {
          'nombreCompleto': nombreCompleto,
          'vehicleDoc': vehicleSnapshot.docs.first
        };
      } else {
        return {
          'nombreCompleto': nombreCompleto
        };
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se encontró coincidencias.')));
      return null;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference soliCollection = FirebaseFirestore.instance.collection('solicitud_mantenimiento');

  Future<int> _getNextSoliId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('SoliId');
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

  Future<void> registerSoli(Map<String, dynamic> solData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in solData.keys) {
      if (solData[key] == null || (solData[key] is String && solData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int solId = await _getNextSoliId();

    await _firestore.collection('solicitud_mantenimiento').doc(solId.toString()).set({
      'id': solId,
      ...solData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchSolicitudes() async {
    QuerySnapshot snapshot = await soliCollection
      .orderBy('estado', descending: true) // Ordena de forma descendente por el campo 'estado'
      .get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> deleteSolicitud(int id) async {
    await _firestore.collection('solicitud_mantenimiento').doc(id.toString()).delete();
  }

  Future<List<Map<String, dynamic>>> searchSolicitudesByPlaca(String placa) async {
    QuerySnapshot snapshot = await _firestore.collection('solicitud_mantenimiento')
      .where('placa', isEqualTo: placa)
      .get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
