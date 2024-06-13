import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/views/maintenance/solicitud/success_validation_screen.dart';


class ValidationController {
  final TextEditingController identiController = TextEditingController();

  Future<String?> validatePerson(BuildContext context) async {
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
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => VehicleInfoScreen(vehicleDoc: vehicleSnapshot.docs.first),
          ),
        );
        return null;
      } else {
        return nombreCompleto;
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se encontró coincidencias.')));
      return null;
    }
  }
}