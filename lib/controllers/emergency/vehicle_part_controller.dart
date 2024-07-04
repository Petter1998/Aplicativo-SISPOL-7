import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/models/emergency/vehicle_model.dart';
import 'package:sispol_7/views/emergency/vehiculo_particular/edit_my_veh_part.dart';

class VehiclePartModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextVehId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('vechiclePartId');
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

    await _firestore.collection('vehiculos_particulares').doc(vehId.toString()).set({
      'id': vehId,
      ...vehData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class VehiclePartController {
  final VehiclePartModel vehiclePartModel = VehiclePartModel();
  final CollectionReference vehiclesCollection = FirebaseFirestore.instance.collection('vehiculos_particulares');

  Future<void> registerVehicle(BuildContext context, Map<String, dynamic> vehData) async {
    try {
      await vehiclePartModel.registerVehicle(vehData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registvehiclepartwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<void> registeVehicle(BuildContext context, Map<String, dynamic> vehData) async {
    try {
      await vehiclePartModel.registerVehicle(vehData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registvehiclepartiwins'); 
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
     throw Exception('Error al actualizar el vehiculo: $e');
    }
  }

  Future<void> deleteVehicle(Vehicle vehicle, String observation) async {
    // Almacenar la observación en la colección eliminacionVehiculo
    await FirebaseFirestore.instance.collection('eliminacionVehiculoParticular').add({
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

  Future<void> updateMyVehiclePart(BuildContext context, Vehicle vehicle) async {
    try {
      await vehiclesCollection.doc(vehicle.id.toString()).update(vehicle.toMap());
      // Redirigir a la ruta /editmyvehicle después de la actualización
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/editmyvehiclepartwins');
    } catch (e) {
      // Mostrar un mensaje de error
      throw Exception('Error al actualizar el vehículo: $e');
    }
  }

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
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
        // Si no se encontró un vehículo, mostrar un mensaje
        // ignore: use_build_context_synchronously
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No tiene un vehículo particular',
            style: GoogleFonts.inter(color: Colors.black),),
              content: Text('No ha registrado un Vehículo Propio.',
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
        // Si se encontró un vehículo, redirigir a la pantalla de edición del vehículo
        Vehicle vehicle = Vehicle.fromMap(vehicleSnapshot.docs.first.data() as Map<String, dynamic>, vehicleSnapshot.docs.first.id);
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => EditMyVehiclePartScreen(vehicle: vehicle),
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