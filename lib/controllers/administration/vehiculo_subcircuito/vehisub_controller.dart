import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';


class VehiSubController {
   final List<int> _selectedIds = [];

    void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  void clearSelection() {
    _selectedIds.clear();
  }

 List<int> get selectedIds => _selectedIds;

  Future<List<Dependecy>> fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    return snapshot.docs.map((doc) => Dependecy.fromMap(doc.data() as Map<String, dynamic>,doc.id)).toList();
  }

  Future<void> assignToSubcircuito(BuildContext context, List<Vehicle> vehicles, String subcircuitoName) async {
    // Obteniendo los datos del subcircuito seleccionado
    DocumentSnapshot subcircuitoDoc = await FirebaseFirestore.instance
        .collection('dependencias')
        .where('nombreSubcircuito', isEqualTo: subcircuitoName)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String subcircuitoDistrito = subcircuitoDoc['nombreDistrito']; // Distrito del subcircuito

    // Verificar si todos los seleccionados pertenecen al mismo distrito
    for (var vehicle in vehicles) {
      if (vehicle.dependencia != subcircuitoDistrito) { // Verificar coincidencia de distrito
        // Lanzar una excepción si no coinciden
        throw Exception('Uno o más vehículos no pueden ser asignados porque pertenecen a un distrito diferente.');
      }
    }

    Map<String, dynamic> subcircuitoData = {
      'nombreCircuito': subcircuitoDoc['nombreCircuito'],
      'distrito': subcircuitoDoc['nombreDistrito'],
      'parroquia': subcircuitoDoc['parroquia'],
      'provincia': subcircuitoDoc['provincia'],
      'nombreSubcircuito': subcircuitoDoc['nombreSubcircuito'],
    };

    // Obtener la fecha y hora actual
    DateTime now = DateTime.now();
    Timestamp fechaAsignacion = Timestamp.fromDate(now); 

    // Guardando el vehiculo con los datos del subcircuito en la colección 'vehiculo_subcircuito'
    final subcircuitoCollection = FirebaseFirestore.instance.collection('vehiculo_subcircuito');
    for (var vehicle in vehicles) {
      await subcircuitoCollection.doc(subcircuitoName).collection(subcircuitoName).add({
        ...vehicle.toMap(),
        'subcircuito': subcircuitoData,
        'fechaAsignacion': fechaAsignacion, // Agregar el campo fechaAsignacion
      });
    }
  }

  Future<bool> isAnyVehicleAlreadyAssigned(List<Vehicle> vehicles, String selectedSubcircuito) async {
    final subcircuitoCollection = FirebaseFirestore.instance.collection('vehiculo_subcircuito');

    for (var vehicle in vehicles) {
      QuerySnapshot snapshot = await subcircuitoCollection
          .where('id', isEqualTo: vehicle.id)
          .limit(vehicles.length) 
          .get();

      for (var doc in snapshot.docs) {
        // Verificar si el vehiculo está asignado a un subcircuito diferente al actual
        if (doc.reference.parent.parent!.id != selectedSubcircuito) {
          return true; // El vehiculo ya está asignado a otro subcircuito
        }
      }
    }

    return false; // Ninguno de los vehiculos está asignado
  }

  Future<List<Map<String, dynamic>>> getAssignedVehicleWithDependency(String subcircuitoName) async {
    QuerySnapshot vehicleSnapshot = await FirebaseFirestore.instance
        .collection('vehiculo_subcircuito')
        .doc(subcircuitoName)
        .collection(subcircuitoName)
        .get();

    List<Map<String, dynamic>> combinedList = [];

    for (var doc in vehicleSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Vehicle vehicle = Vehicle.fromMap(data, doc.id);

      // Obtener los datos del subcircuito directamente del documento de la flota vehicular
      Map<String, dynamic> subcircuitoData = data['subcircuito'] ?? {}; // Si no existe 'subcircuito', usar un mapa vacío

      // Incluir 'fechaAsignacion' si existe en data
      if (data.containsKey('fechaAsignacion')) {
        subcircuitoData['fechaAsignacion'] = data['fechaAsignacion'];
      }

      // Buscar la dependencia correspondiente al vehiculo (como antes)
      var dependecy = (await fetchDependencias()).firstWhere(
            // ignore: unrelated_type_equality_checks
            (dep) => dep.id == vehicle.dependencia,
            orElse: () => Dependecy(
              id: 0,
              provincia: '',
              nDistr: 0,
              parroquia: '',
              codDistr: '',
              nameDistr: '',
              nCircuit: 0,
              codCircuit: '',
              nameCircuit: '',
              nsCircuit: 0,
              codsCircuit: '',
              namesCircuit: '',
              fechacrea: null,
            ),
          );

      combinedList.add({
        'vehiculos': vehicle,
        'dependencias': dependecy,
        'subcircuito': subcircuitoData,
      });
    }
    return combinedList;
  }

  Future<List<String>> getUniqueDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('vehiculos').get();

    Set<String> uniqueDependencias = {};
    for (var doc in snapshot.docs) {
      String dependencia = doc['dependencia'];
      // ignore: unnecessary_null_comparison
      if (dependencia != null && dependencia.isNotEmpty) {
        uniqueDependencias.add(dependencia);
      }
    }
    return uniqueDependencias.toList();
  }

  Future<List<Vehicle>> searchVehicle(String dependencia) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('vehiculos')
        .where('dependencia', isEqualTo: dependencia)
        .get();

    return snapshot.docs.map((doc) => Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> reassignSelected(
    BuildContext context,
    List<Map<String, dynamic>> vehicleData,
    String newSubcircuitoName,
    String currentSubcircuitoName
  ) async {
    // Obteniendo los datos del nuevo subcircuito seleccionado
    DocumentSnapshot newSubcircuitoDoc = await FirebaseFirestore.instance
        .collection('dependencias')
        .where('nombreSubcircuito', isEqualTo: newSubcircuitoName)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String newSubcircuitoDistrito = newSubcircuitoDoc['nombreDistrito'];

    // Filtrar el personalData para obtener solo los seleccionados
    List<Map<String, dynamic>> selectedVehicleData = vehicleData.where((item) => _selectedIds.contains(item['vehiculos'].id)).toList();

    if (selectedVehicleData.isEmpty) {
      throw Exception('No se ha seleccionado ningún vehiculo para reasignar.');
    }

    // Verificar si todos los seleccionados pertenecen al mismo distrito
    for (var item in selectedVehicleData) {
      final vehicle = item['vehiculos'] as Vehicle;
      if (vehicle.dependencia != newSubcircuitoDistrito) {
        throw Exception('Uno o más registros no pueden ser reasignados porque pertenecen a un distrito diferente.');
      }
    }

    // Actualizar los datos en Firestore dentro de una transacción
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      for (var item in selectedVehicleData) {
        final vehicle = item['vehiculos'] as Vehicle;

        // Buscar el documento del vehiculo en la colección del subcircuito actual
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('vehiculo_subcircuito')
            .doc(currentSubcircuitoName)
            .collection(currentSubcircuitoName)
            .where('id', isEqualTo: vehicle.id) // Filtrar por el ID del vehiculo
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Eliminar el documento del subcircuito actual
          transaction.delete(querySnapshot.docs.first.reference);

          // Crear los datos del nuevo subcircuito
          Map<String, dynamic> newSubcircuitoData = {
            'nombreCircuito': newSubcircuitoDoc['nombreCircuito'],
            'distrito': newSubcircuitoDoc['nombreDistrito'],
            'parroquia': newSubcircuitoDoc['parroquia'],
            'provincia': newSubcircuitoDoc['provincia'],
            'nombreSubcircuito': newSubcircuitoDoc['nombreSubcircuito'],
          };

          // Agregar el registro al nuevo subcircuito
          transaction.set(FirebaseFirestore.instance
              .collection('vehiculo_subcircuito')
              .doc(newSubcircuitoName)
              .collection(newSubcircuitoName)
              .doc(),
            {
              ...vehicle.toMap(),
              'subcircuito': newSubcircuitoData,
            });
        } else {
          throw Exception('No se encontró el registro del vehiculo con ID ${vehicle.id}');
        }
      }
    });
  }

  Future<void> deleteSelected(String currentSubcircuitoName) async {
    if (_selectedIds.isEmpty) {
      throw Exception('No se ha seleccionado ningún vehiculo para eliminar.');
    }

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        for (int id in _selectedIds) {
          // ignore: avoid_print
          print('Intentando eliminar ID: $id'); 

          // Buscar el documento del vehiculo en la subcolección
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('vehiculo_subcircuito')
              .doc(currentSubcircuitoName)
              .collection(currentSubcircuitoName)
              .where('id', isEqualTo: id)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot vehicle = querySnapshot.docs.first;
            // ignore: avoid_print
            print('Eliminando documento con ID: ${vehicle.id}'); // Imprime el ID del documento a eliminar
            transaction.delete(vehicle.reference);
          } else {
            // ignore: avoid_print
            print('No se encontró el documento con ID: $id'); // Imprime un mensaje si no se encuentra el documento
          }
        }
      }).then((_) {
        // ignore: avoid_print
        print('Transacción completada con éxito');
      }).catchError((error) {
        // ignore: avoid_print
        print('Error en la transacción: $error');
      });

      _selectedIds.clear();
    } catch (e) {
      // ignore: avoid_print
      print('Error general al eliminar: $e'); // Captura cualquier otro error
      throw Exception('Error al eliminar registros.'); 
    }
  }
}