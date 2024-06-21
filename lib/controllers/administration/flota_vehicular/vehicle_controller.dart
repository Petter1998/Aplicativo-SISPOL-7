import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';

class VehicleModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextVehId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('vechicleId');
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

  Future<void> registerVehicle(Map<String, dynamic> vehData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in vehData.keys) {
      if (vehData[key] == null || (vehData[key] is String && vehData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de Vehiculo
    int vehId = await _getNextVehId();

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

  Future<List<Vehicle>> fetchVehicles() async {
    QuerySnapshot snapshot = await vehiclesCollection.get();
    List<Vehicle> vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    vehicles.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return vehicles;
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await vehiclesCollection.doc(vehicle.id.toString()).update(vehicle.toMap());
    } catch (e) {
      // Mostrar un mensaje de error
     throw Exception('Error al actualizar el personal: $e');
    }
  }

  Future<void> deleteVehicle(Vehicle vehicle, String observation) async {
    // Almacenar la observación en la colección eliminacionVehiculo
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
}