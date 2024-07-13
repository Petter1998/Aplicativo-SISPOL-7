import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';
import 'package:sispol_7/views/administration/flota_vehicular/edit_my_vehicle.dart';

class VehicleModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene el siguiente ID disponible para un nuevo vehículo
  Future<int> _getNextVehId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('vechicleId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        // Si no existe el documento de contador, lo crea y establece el ID inicial en 1
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      // Incrementa el ID actual en 1 y actualiza el documento
      int newId = snapshot['currentId'] + 1;
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

  // Registra un nuevo vehículo en Firestore
  Future<void> registerVehicle(Map<String, dynamic> vehData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in vehData.keys) {
      if (vehData[key] == null || (vehData[key] is String && vehData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de Vehiculo
    int vehId = await _getNextVehId();

    // Guarda el vehículo en Firestore con la fecha de creación actual
    await _firestore.collection('vehiculos').doc(vehId.toString()).set({
      'id': vehId,
      ...vehData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class VehicleController {
  final VehicleModel vehicleModel = VehicleModel();
  final CollectionReference vehiclesCollection = FirebaseFirestore.instance.collection('vehiculos');

  // Registra un nuevo vehículo y navega a otra pantalla en caso de éxito
  Future<void> registerVehicle(BuildContext context, Map<String, dynamic> vehData) async {
    try {
      await vehicleModel.registerVehicle(vehData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registvehiclewins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

   // Obtiene una lista de todos los vehículos desde Firestore
  Future<List<Vehicle>> fetchVehicles() async {
    QuerySnapshot snapshot = await vehiclesCollection.get();
    List<Vehicle> vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    vehicles.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return vehicles;
  }

  // Actualiza un vehículo existente en Firestore
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await vehiclesCollection.doc(vehicle.id.toString()).update(vehicle.toMap());
    } catch (e) {
      // Mostrar un mensaje de error
     throw Exception('Error al actualizar el personal: $e');
    }
  }

  // Elimina un vehículo de Firestore, registrando la observación
  Future<void> deleteVehicle(Vehicle vehicle, String observation) async {
    // Almacena la observación en la colección eliminacionVehiculo
    await FirebaseFirestore.instance.collection('eliminacionVehiculo').add({
      'vehiculoId': vehicle.id,
      'modelo': vehicle.modelo,
      'marca': vehicle.marca,
      'placa': vehicle.placa,
      'chasis': vehicle.chasis,
      'observaciones': observation,
      'fechaEliminacion': FieldValue.serverTimestamp(),
    });

    // Eliminar de Firestore
    await vehiclesCollection.doc(vehicle.id.toString()).delete();
  }

  // Busca vehículos en Firestore cuyo placa o chasis coincidan con la consulta dada
  Future<List<Vehicle>> searchVehicle(String query) async {
    Query queryRef = vehiclesCollection;

    if (query.isNotEmpty) {
      queryRef = queryRef.where(
        'placa',
        isEqualTo: query,
      );

      QuerySnapshot snapshotPlaca = await queryRef.get();
      List<Vehicle> vehiclesPlaca = snapshotPlaca.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      if (vehiclesPlaca.isNotEmpty) {
        return vehiclesPlaca;
      }

      queryRef = vehiclesCollection.where(
        'chasis',
        isEqualTo: query,
      );

      QuerySnapshot snapshotChasis = await queryRef.get();
      List<Vehicle> vehiclesChasis = snapshotChasis.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      return vehiclesChasis;
    }
    return [];
  }

  // Actualiza un vehículo propio y navega a otra pantalla en caso de éxito
  Future<void> updateMyVehicle(BuildContext context, Vehicle vehicle) async {
    try {
      await vehiclesCollection.doc(vehicle.id.toString()).update(vehicle.toMap());
      // Redirigir a la ruta /editmyvehicle después de la actualización
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/editmyvehiclewins');
    } catch (e) {
      // Mostrar un mensaje de error
      throw Exception('Error al actualizar el vehículo: $e');
    }
  }

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  // Busca el vehículo asignado al usuario actual
  Future<void> findVehicleForCurrentUser(BuildContext context) async {
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
      String nombreCompleto = '$nombres $apellidos';

      // Buscar un vehículo donde el nombre completo coincida con uno de los responsables
      QuerySnapshot vehicleSnapshot = await vehiclesCollection
        .where('responsable1', isEqualTo: nombreCompleto)
        .get();

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await vehiclesCollection
          .where('responsable2', isEqualTo: nombreCompleto)
          .get();
      }

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await vehiclesCollection
          .where('responsable3', isEqualTo: nombreCompleto)
          .get();
      }

      if (vehicleSnapshot.docs.isEmpty) {
        vehicleSnapshot = await vehiclesCollection
          .where('responsable4', isEqualTo: nombreCompleto)
          .get();
      }

      if (vehicleSnapshot.docs.isEmpty) {
        // Si no se encontró un vehículo, mostrar un mensaje
        // ignore: use_build_context_synchronously
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No tiene un vehículo a su cargo',
            style: GoogleFonts.inter(color: Colors.black),),
              content: Text('No se encontró ningún vehículo asignado a su nombre.',
            style: GoogleFonts.inter(color: Colors.black),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar',
            style: GoogleFonts.inter(color: Colors.black),),
                ),
              ],
            );
          },
        );
      } else {
        // Si se encontró un vehículo, redirige a la pantalla de edición del vehículo
        Vehicle vehicle = Vehicle.fromMap(vehicleSnapshot.docs.first.data() as Map<String, dynamic>, vehicleSnapshot.docs.first.id);
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => EditMyVehicleScreen(vehicle: vehicle),
          ),
        );
      }
    } catch (e) {
      // Mostrar mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al buscar vehículo: $e')));
    }
  }
}