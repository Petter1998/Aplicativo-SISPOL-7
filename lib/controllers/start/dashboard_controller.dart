import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MaintenanceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getVehicleMaintenanceData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('solicitud_mantenimiento').get();
    Map<String, int> vehicleCounts = HashMap();

    for (var doc in querySnapshot.docs) {
      String vehicle = doc['tipo'];
      if (vehicleCounts.containsKey(vehicle)) {
        vehicleCounts[vehicle] = vehicleCounts[vehicle]! + 1;
      } else {
        vehicleCounts[vehicle] = 1;
      }
    }
    return vehicleCounts;
  }

  // Método para obtener los datos de "monto" agrupados por mes
  Future<Map<String, double>> getMonthlyAmounts() async {
    Map<String, double> monthlyAmounts = {};

    QuerySnapshot snapshot = await _firestore.collection('documentos').get();

    DateTime now = DateTime.now();
    DateTime threeMonthsAgo = DateTime(now.year, now.month - 2, 1);

    for (var doc in snapshot.docs) {
      String dateString = doc['fecha'];
      DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);
      if (date.isAfter(threeMonthsAgo) || (date.year == threeMonthsAgo.year && date.month == threeMonthsAgo.month)) {
        double amount = doc['total'];
        String month = DateFormat('MMM').format(date);
        if (monthlyAmounts.containsKey(month)) {
          monthlyAmounts[month] = monthlyAmounts[month]! + amount;
        } else {
          monthlyAmounts[month] = amount;
        }
      }
    }
    return monthlyAmounts;
  }

  Future<Map<String, int>> getMaintenanceTypeData() async {
    final snapshot = await FirebaseFirestore.instance.collection('documentos').get();
    final data = snapshot.docs.map((doc) => doc.data()).toList();

    Map<String, int> maintenanceTypeCounts = {};
    for (var entry in data) {
      String maintenanceType = entry['tipoMantenimiento'];
      List<String> types = maintenanceType.split(', '); // Suponiendo que los tipos están separados por comas
      for (var type in types) {
        if (maintenanceTypeCounts.containsKey(type)) {
          maintenanceTypeCounts[type] = maintenanceTypeCounts[type]! + 1;
        } else {
          maintenanceTypeCounts[type] = 1;
        }
      }
    }
    return maintenanceTypeCounts;
  }

  Future<Map<String, double>> getContractAmountsByType() async {
    // Simulamos la obtención de datos de Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('contratos').get();

    Map<String, double> data = {};
    for (var doc in querySnapshot.docs) {
      String tipoContrato = doc['tipoContrato'];
      double monto = doc['monto'];

      if (data.containsKey(tipoContrato)) {
        data[tipoContrato] = data[tipoContrato]! + monto;
      } else {
        data[tipoContrato] = monto;
      }
    }
    return data;
  }

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  Future<Map<String, int>> getKilometrajeData(BuildContext context) async {
    try {
      // Obtener el usuario actual
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No se encontró al usuario actual.');
      }

      // Obtener los nombres y apellidos del usuario actual
      DocumentSnapshot userDoc = await usersCollection.doc(currentUser.uid).get();
      String nombres = userDoc.get('nombres');
      String apellidos = userDoc.get('apellidos');
      String currentUserFullName = '$nombres $apellidos';

      int? kilometraje;
      int? kilometrajeActual;
      int? kilometrajeProximoMant;

      // Obtener vehículos asignados al usuario
      List<QueryDocumentSnapshot<Map<String, dynamic>>> vehicleDocs = [];
      
      // Consultar la colección 'vehiculos' para encontrar documentos donde el usuario actual
      // es responsable en uno de los cuatro campos posibles
      var vehiclesQuery1 = await _firestore.collection('vehiculos')
          .where('responsable1', isEqualTo: currentUserFullName)
          .get();
      vehicleDocs.addAll(vehiclesQuery1.docs);

      if (vehicleDocs.isEmpty) {
        var vehiclesQuery2 = await _firestore.collection('vehiculos')
            .where('responsable2', isEqualTo: currentUserFullName)
            .get();
        vehicleDocs.addAll(vehiclesQuery2.docs);
      }

      if (vehicleDocs.isEmpty) {
        var vehiclesQuery3 = await _firestore.collection('vehiculos')
            .where('responsable3', isEqualTo: currentUserFullName)
            .get();
        vehicleDocs.addAll(vehiclesQuery3.docs);
      }

      if (vehicleDocs.isEmpty) {
        var vehiclesQuery4 = await _firestore.collection('vehiculos')
            .where('responsable4', isEqualTo: currentUserFullName)
            .get();
        vehicleDocs.addAll(vehiclesQuery4.docs);
      }

      // Si se encontró al menos un vehículo, obtener su kilometraje
      if (vehicleDocs.isNotEmpty) {
        kilometraje = vehicleDocs.first['kilometraje'];

        // Consultar la colección 'reportes' para encontrar documentos donde el usuario actual
        // es responsable en los campos 'responsableEntrega' o 'responsableRetira'
        List<QueryDocumentSnapshot<Map<String, dynamic>>> reportesDocs = [];
        var reportesQuery1 = await _firestore.collection('reportes')
            .where('responsableEntrega', isEqualTo: currentUserFullName)
            .get();
        reportesDocs.addAll(reportesQuery1.docs);

        if (reportesDocs.isEmpty) {
          var reportesQuery2 = await _firestore.collection('reportes')
              .where('responsableRetira', isEqualTo: currentUserFullName)
              .get();
          reportesDocs.addAll(reportesQuery2.docs);
        }

        // Si se encontró al menos un reporte, obtener su kilometrajeProximoMant
        if (reportesDocs.isNotEmpty) {
          kilometrajeActual = reportesDocs.first['kilometrajeActual'];
          kilometrajeProximoMant = reportesDocs.first['kilometrajeProximoMant'];
        }
      }

      // Si ambos valores se obtuvieron correctamente, devolverlos en un mapa
      if (kilometraje != null && kilometrajeActual != null && kilometrajeProximoMant != null) {
        return {
          'kilometraje': kilometraje,
          'kilometrajeActual': kilometrajeActual,
          'kilometrajeProximoMant': kilometrajeProximoMant,
        };
      } else {
        // Si no se encontraron datos válidos, devolver valores por defecto
        return {
          'kilometraje': 0,
          'kilometrajeActual': 0,
          'kilometrajeProximoMant': 0,
        };
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      return {
        'kilometraje': 0,
        'kilometrajeActual': 0,
        'kilometrajeProximoMant': 0,
      };
    }
  }

  // Método para obtener el rol del usuario
  Future<String> getUserRole() async {
    auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No se encontró al usuario actual.');
    }

    DocumentSnapshot userDoc = await usersCollection.doc(currentUser.uid).get();
    return userDoc.get('cargo');
  }
}

